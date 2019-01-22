<template>
    <form class="row Group__question">
        <!-- TITLE -->
        <div class="Group__question-row">
            <div class="Group__question-label">Текст вопроса:</div>
            <div class="input-field Group__question-value text">
                <input type="text" v-model="text">
                <validation :formKey="formName" field="text"/>
            </div>
            <!-- delete -->
            <i class="material-icons Group__question-delete" @click="deleteQuestion(question.id)">close</i>
        </div>
        <!-- KIND -->
        <div class="Group__question-row">
            <div class="Group__question-label">Тип вопроса:</div>
            <div class="Group__question-value">
                <label class="Group__question-valueLabel">
                    <input name="kind" type="radio" value="text" v-model="kind"/>
                    <span> открытый </span>
                </label>
                <label class="Group__question-valueLabel">
                    <input name="kind" type="radio" value="one" v-model="kind"/>
                    <span> один вариант ответа </span>
                </label>
                <label class="Group__question-valueLabel" >
                    <input name="kind" type="radio" value="many" v-model="kind"/>
                    <span> несколько вариантов ответа </span>
                </label>
                <validation :formKey="formName" field="kind"/>
            </div>
        </div>
        <!-- VARIANTS -->
        <div class="Group__question-row" v-if="kind && kind !== 'text'">
            <div class="Group__question-label">Варианты ответов:</div>
            <div>
                <variants
                    v-for="(variant, indexVariant) in variants"
                    :kind="kind"
                    :answer="answer"
                    :indexQuestion="question.index"
                    :indexVariant="indexVariant"
                    :variant="variant"
                    @selectVariant="handleSelectVariant"
                    @editVariant="handleEditVariant"
                />
                <button class="btn waves-effect waves-light Group__question-add" @click="addVariant">добавить вариант</button>
            </div>
        </div>
    </form>
</template>

<script>
    import { mapState, mapMutations, mapActions } from "vuex";
    import variants from "../components/GroupQuestionVariants";
    import validation from "../components/BaseValidationError";

    export default {
        name: "GroupQuestionsForm",
        props: {
            question: {
                type: Object,
                default: {}
            }
        },
        components: {
            variants,
            validation,
        },
        computed: {
            ...mapState({
                field(_, getters) {
                    return getters[`${this.formName}/field`];
                },
            }),
            formName() {
                return `questionForm-${this.question.index}`
            },
            id: {
                get() {
                    return this.field("id");
                },
                set(value) {},
            },
            text: {
                get() {
                    return this.field("text");
                },
                set(value) {
                    this.changeField({ field: "text", value });
                },
            },
            kind: {
                get() {
                    return this.field("kind");
                },
                set(value) {
                    this.changeField({ field: "kind", value });
                    this.changeField({ field: "answer", value: null });
                },
            },
            variants: {
                get() {
                    return this.field("variants");
                },
                set(value) {
                    this.changeField({ field: "variants", value });
                },
            },
            answer: {
                get() {
                    return this.field("answer");
                },
                set(value) {
                    this.changeField({ field: "answer", value });
                },
            },
        },
        methods: {
            ...mapMutations(["removeMember"]),
            ...mapMutations({
                setData(commit, payload) {
                    return commit(
                        `${this.formName}/setData`,
                        payload
                    );
                }
            }),
            ...mapActions({
                submit(dispatch, payload) {
                    return dispatch(
                        `${this.formName}/submit`,
                        payload
                    );
                },
                changeField(dispatch, payload) {
                    return dispatch(
                        `${this.formName}/changeField`,
                        payload
                    );
                },
            }),
            ...mapActions(["deleteQuestion"]),
            addVariant(e) {
                e.preventDefault();

                if (this.variants === undefined) { // if question is new
                    this.variants = [];
                }

                this.variants.push("");
            },
            handleSelectVariant(value) {
                this.setData({ fields: {
                        answer: value
                    }
                })
            },
            handleEditVariant(index, value) {
                const newVariants = this.variants.map((variant, i) => {
                    return (index === i) ? value : variant
                });

                this.setData({ fields: {
                        variants: newVariants
                    }
                })
            }
        },
        mounted() {
            this.setData({ fields: {
                id: this.question.id,
                text: this.question.text,
                kind: this.question.kind,
                variants: this.question.variants,
                answer: this.question.answer
            }});
        }
    }
</script>

<style lang="scss" scoped>
    .Group {
        &__question {
            border-bottom: 1px solid #827f7f;
            padding-bottom: 15px;
            margin-bottom: 35px;

            &-row {
                display: flex;
                margin-bottom: 1rem;
            }

            &-label {
                width: 23%;
                flex-shrink: 0;
            }

            &-value {
                flex-grow: 1;

                &.text {
                    margin-top: -10px;
                    margin-bottom: 0;

                    input {
                        border-bottom: 1px solid #cacaca;
                    }
                }

                &Label {
                    color: rgba(0,0,0,0.87);
                    display: flex;
                    justify-content: space-between;
                }
            }

            &-add {
                margin-top: 12px;
                background: #efefef;
                color: #1e887e;
                font-weight: 600;
                font-size: 14px;
                text-transform: lowercase;

                &.question {
                    max-width: 240px;
                    align-self: center;
                    margin-top: -1rem;
                    margin-bottom: 3rem;
                }
            }

            &-delete {
                color: #26a69a;
                transition: transform .3s;
                transform-origin: center;

                &:hover {
                    cursor: pointer;
                    transform: scale(1.1);
                }
            }
        }
    }
</style>
<style lang="scss">
</style>