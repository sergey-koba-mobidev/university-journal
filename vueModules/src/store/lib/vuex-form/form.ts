import { ActionContext, Commit, Dispatch, Module } from "vuex";
import { Map, Set } from "immutable";
import { isString, throttle, isFunction, isArray } from "lodash";

type FieldTypes = String | Number | Boolean | Object;

export type Validator = (
    value,
    fields: Hash<any>,
    rootState: any,
    rootGetters: any,
) => void | string;

export function mapFieldsToComputed(formKey: string, fields: string[]) {
    return fields.reduce((acc, field) => {
        acc[field] = {
            get() {
                return this.$store.getters[`${formKey}/field`](field);
            },
            set(value) {
                this.$store.dispatch(`${formKey}/changeField`, {value, field});

                return value;
            }
        }

        return acc;
    }, {});
}

export interface InterceptorContext {
    value: any;
    commit: Commit;
    dispatch: Dispatch;
    fields: Hash<any>;
    rootState: any;
    rootGetters: any;
    meta: any;
}

export interface FieldConfig {
    type: StringConstructor | NumberConstructor | BooleanConstructor | ObjectConstructor;
    validators?: Validator[];
    interceptor?(ctx: InterceptorContext): any;
}

type FieldsHash<TField> = { [K in keyof TField]: FieldConfig };
export type DefaultValues = {[field: string]: any};

interface FormOptions<TField> {
    fields: FieldsHash<TField>;
    defaultValues?: DefaultValues;
    throttle?: number;
    onSubmit(ctx: ActionContext<FormState<TField>, any>, payload: any): void;
}

type FieldsState<TFields, K extends keyof TFields = keyof TFields> = Map<
    K,
    TFields[K]
>;
type ErrorsState<TFields> = Map<keyof TFields, string[]>;

interface FormState<TFields> {
    submited: boolean;
    fetchStatus: FetchStatus;
    touched: Set<keyof TFields>;
    fields: FieldsState<TFields>;
    errors: ErrorsState<TFields>;
}

interface SubmitMeta {
    validate?: boolean;
    validateOnly?: string[];
}

export class Form<TFields = any> implements Module<FormState<TFields>, any> {
    readonly fields: FieldsHash<TFields>;
    readonly defaultValues: DefaultValues | undefined;
    readonly onSubmit: (
        context: ActionContext<FormState<TFields>, any>,
        payload: any
    ) => void;

    public namespaced = true;
    public state: FormState<TFields>;

    constructor(private options: FormOptions<TFields>) {
        this.fields = this.options.fields;
        this.defaultValues = this.options.defaultValues;
        this.onSubmit = this.options.onSubmit;
        this.state = this.getDefaultState();

        if (this.options.throttle) {
            this.throttledValidate = throttle(
                this.throttledValidate,
                this.options.throttle
            );
        }
    }

    get mutations() {
        const self = this;

        return {
            setFetchStatus(state, status: FetchStatus) {
                state.fetchStatus = status;
            },
            setSubmited(state, submited: boolean) {
                state.submited = submited;
            },
            reset(state, params: { clearFields: boolean }) {
                state.submited = false;
                state.valid = false;

                state.errors = state.errors.clear();
                state.fetchStatus = "init";
                state.touched = state.touched.clear();

                if (params && params.clearFields) {
                    state.fields = self.generateFields();
                }
            },
            setErrors(state, { errors }) {
                const map = Map(errors)
                    .filter((value, key) => state.fields.has(key) || key === "form");

                state.errors = state.errors.merge(map);
            },
            setFieldValue(state, { field, value }) {
                state.fields = state.fields.set(field, value);
            },
            setTouched(state, { field }) {
                state.touched = state.touched.add(field);
            },
            setData(state, { fields }) {
                if (Object.keys(fields).some(k => !state.fields.has(k))) {
                    throw new Error(
                        "You can't set fields that don't exist in config"
                    );
                }

                state.fields = state.fields.merge(fields);
            }
        };
    }

    get actions() {
        const self = this;

        return {
            async setData({ commit, state, dispatch }, { fields, validate }) {
                commit("setData", { fields });

                if (validate) {
                    const validateFields = isArray(validate)
                        ? validate
                        : Object.keys(fields);

                    for (let field of validateFields) {
                        await dispatch("validate", { field });
                    }
                }

                return Promise.resolve();
            },
            changeField({ commit, state, dispatch, rootState, rootGetters }, { field, value, noInterceptors, noValidate, meta }) {
                if (!state.touched.has(field)) {
                    commit("setTouched", { field });
                }

                if (isString(value)) {
                    value = value.trim();
                }

                if (self.fields[field].interceptor && !noInterceptors) {
                    value = self.fields[field].interceptor({
                        value,
                        commit,
                        fields: state.fields.toObject(),
                        rootState,
                        rootGetters,
                        dispatch,
                        meta
                    });
                }

                commit("setFieldValue", { field, value });

                if (noValidate) {
                    return;
                }

                self.throttledValidate(dispatch, { field });
            },
            async validate({ commit, state, getters, rootState, rootGetters }, { field }) {
                const value = getters.field(field);
                const errors = self.validateField(
                    field,
                    value,
                    state.fields.toObject(),
                    rootState,
                    rootGetters
                );

                if (typeof getters.error(field) === "undefined" && errors.length === 0) {
                    return Promise.resolve();
                }

                commit("setErrors", {
                    errors: { [field]: errors, form: [] }
                });

                return Promise.resolve();
            },
            async validateAll(
                { commit, dispatch, state, getters },
                { validateOnly }
            ) {
                const fields = state.fields;

                if ((validateOnly || []).some(f => !fields.has(f))) {
                    throw new Error(
                        "Validate only should contain only existing fields"
                    );
                }

                await Promise.all(
                    fields
                        .filter(
                            (f, field) =>
                                (validateOnly || []).length !== 0
                                ? validateOnly.includes(field)
                                : true
                        )
                        .map((f, field) => dispatch("validate", { field }))
                );

                return Promise.resolve();
            },
            async submit(
                ctx,
                params: { payload: any; meta: SubmitMeta }
            ) {
                const {meta, payload} = params || {} as any;

                if (!ctx.state.submited) {
                    ctx.commit("setSubmited", true);
                }

                const validate = meta && meta.validate ? meta.validate : true;

                if (validate) {
                    await ctx.dispatch("validateAll", {
                        validateOnly: meta && meta.validateOnly
                    });
                }

                const isValid = ctx.getters.isValid(meta && meta.validateOnly);

                if (validate && !isValid) {
                    return Promise.resolve();
                }

                await self.onSubmit(ctx, payload);

                return Promise.resolve();
            }
        };
    }

    get getters() {
        return {
            loading(state) {
                return state.fetchStatus === "loading";
            },
            isValid: state => (validateOnly: string[] = []) => {
                return !state.errors.some(
                    (e, field) =>
                        validateOnly.length !== 0
                            ? validateOnly.includes(field) && e.length !== 0
                            : e.length !== 0
                );
            },
            field: state => field => {
                return state.fields.get(field);
            },
            allFields: state => {
                return state.fields.toObject();
            },
            error: state => field => {
                return (state.errors.get(field) || [])[0];
            }
        };
    }

    private getDefaultState(): FormState<TFields> {
        return {
            submited: false,
            fetchStatus: "init",
            touched: Set(),
            fields: this.generateFields(),
            errors: Map()
        };
    }

    private throttledValidate(dispatch, { field }) {
        dispatch("validate", { field });
    }

    private generateFields(): FieldsState<TFields> {
        return Object.keys(this.fields).reduce(
            (acc, fieldName) => {
                const field = this.fields[fieldName];
                const defaultValue = this.defaultValues && this.defaultValues[fieldName] || this.getFieldDefaultValue(field.type);

                return acc.set(fieldName as any, defaultValue as any);
            },
            Map() as FieldsState<TFields>
        );
    }

    private getFieldDefaultValue(type: FieldTypes): string | number | boolean {
        if (!type) {
            throw new Error("Type is required");
        }

        return (type as any)();
    }

    private validateField(
        field: string,
        value: any,
        fields: Hash<any>,
        rootState: any,
        rootGetters: any
    ): string[] {
        const { validators } = this.fields[field];
        const errors = (validators || []).reduce((acc, validator) => {
            if (!isFunction(validator)) {
                throw new Error("Validator should be function.");
            }

            let result;
            try {
                result = validator(value, fields, rootState, rootGetters);
            } catch (e) {
                console.error(e);
            }

            if (result) {
                if (!isString(result)) {
                    throw new Error(
                        "Validator should return string if invalid."
                    );
                }

                acc.push(result);
            }

            return acc;
        }, []);

        return errors;
    }
}
