import { Module } from "vuex";
import api from "./lib/api";
import {Form, required, digits} from "./lib/vuex-form";

type QuestionType = {
    id: number;
    text: string;
    variants: string[];
    kind: string;
}

export interface ModuleState {
    fetchStatus: FetchStatus;
    fetchSaveModuleStatus: FetchStatus;
    questions: QuestionType;
    discipline: string;
    module: string;
    showModal: Boolean;
    disciplineId: number | null,
    moduleId: number | null,
}

const module: Module<ModuleState, {}> = {
    state: {
        fetchStatus: "init",
        fetchSaveModuleStatus: "init",
        questions: {} as QuestionType,
        discipline: "",
        module: "",
        showModal: false,
        disciplineId: null,
        moduleId: null,
    },
    mutations: {
        setFetchStatus(state, status: FetchStatus) {
            state.fetchStatus = status;
        },
        setQuestions(state, questions) {
            state.questions = questions;
        },
        setDisciplineName(state, name) {
            state.discipline = name;
        },
        setModuleName(state, name) {
            state.module = name;
        },
        openModuleModal(state) {
            state.showModal = true
        },
        closeModuleModal(state) {
            state.showModal = false
        },
        setIds(state, { disciplineId, moduleId }) {
            state.disciplineId = disciplineId;
            state.moduleId = moduleId;
        }
    },
    actions: {
        async getModule({commit},  { disciplineId, moduleId }) {
            commit("setFetchStatus", "loading");

            const disciplines = JSON.parse(localStorage.getItem("disciplines"));

            for (let discipline of disciplines) {
                if (discipline.id == disciplineId) {
                    commit("setDisciplineName", discipline.name);

                    for (let module of discipline.modules) {
                        if (module.id == moduleId) {
                            commit("setModuleName", module.title);
                        }
                    }
                }
            }

            const { status, response, errors} = await api.getModule(disciplineId, moduleId);

            if (status !== 0) {
                console.error(errors);
            }

            const questions = response.questions.map(item => ({
                id: item.id,
                kind: item.kind === "text"
                    ? "text"
                    : item.kind === "one"
                        ? "radio"
                        : "checkbox",
                text: item.description,
                variants: item.variants
            }));

            commit("setQuestions", questions);
            commit("setFetchStatus", "ok");
        },
        async postAnswers({},{ disciplineId, moduleId, questionId, answer } ) {
            const body = {
                "answer": answer
            };
            const { status, response, errors} = await api.postAnswer({
                params: {
                    disciplineId,
                    moduleId,
                    questionId
                },
                body
            });
        },
        // teacher part
        initModuleForm({ commit }, { disciplineId, moduleId }) {
            // TODO add getting current module data
            commit("setIds", { disciplineId, moduleId });
        }
    },
    modules: {
        moduleEditForm: new Form({
            throttle: 300,
            fields: {
                title: {
                    type: String,
                    validators: [
                        required(),
                    ],
                },
                duration: {
                    type: String,
                    validators: [
                        required(),
                        digits(),
                    ],
                },
            },
            async onSubmit({ rootState, commit, dispatch, getters }) {
                const params = {
                    disciplineId: rootState.module.disciplineId,
                    moduleId: rootState.module.moduleId
                };

                const body = {
                    title : getters['field']("title"),
                    duration : getters['field']("duration"),
                };

                console.log(params);

                const { errors } = await api.postUpdateModule({ params, body });

                if (errors) {
                    console.error(errors);
                    return
                }
            },
        }),
    }
};

export default module;
