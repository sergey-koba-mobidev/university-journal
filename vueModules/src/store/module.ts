import { Module } from "vuex";
import api from "./lib/api";
import { Form, required, digits } from "./lib/vuex-form";
import router from "../main";

type QuestionType = {
    id: number;
    text: string;
    variants: string[];
    kind: string;
}

export interface ModuleState {
    fetchGetModuleStatus: FetchStatus;
    fetchGetInfoStatus: FetchStatus;
    fetchSaveInfoStatus: FetchStatus;
    questions: QuestionType;
    discipline: string;
    module: string;
    showModal: Boolean;
    showFinishModal: Boolean;
    disciplineId: number | null,
    moduleId: number | null,
    time: string,
}

const module: Module<ModuleState, {}> = {
    namespaced: true,
    state: {
        fetchGetModuleStatus: "init",
        fetchGetInfoStatus: "init",
        fetchSaveInfoStatus: "init",
        questions: {} as QuestionType,
        discipline: "",
        module: "",
        showModal: false,
        showFinishModal: false,
        disciplineId: null,
        moduleId: null,
        time: "",
    },
    mutations: {
        setFetchStatus(state, { name, status }) {
            state[`fetch${name}Status`] = status;
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
        setModuleTime(state, time) {
            state.time = time;
        },
        openModuleModal(state) {
            state.showModal = true;
        },
        closeModuleModal(state) {
            state.showModal = false;
        },
        setIds(state, { disciplineId, moduleId }) {
            state.disciplineId = disciplineId;
            state.moduleId = moduleId;
        }
    },
    actions: {
        // student part
        async getModule({ commit },  { disciplineId, moduleId }) {
            commit("setFetchStatus", {name: "GetModule", status: "loading"});

            // just for title
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

            const openedUntil = new Date(response.opened_until).getTime();
            const now = new Date().getTime();
            const time = Math.round((openedUntil - now)/1000);

            commit("setModuleTime", time);

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
            commit("setFetchStatus", {name: "GetModule", status: "ok"});
        },
        async postAnswers({},{ relationshipId, disciplineId, moduleId, questionId, answer } ) {
            const body = {
                "answer": answer
            };

            await api.postAnswer({
                params: {
                    relationshipId,
                    disciplineId,
                    moduleId,
                    questionId
                },
                body
            });

            // TODO set results
        },
        async finishModule({ state, commit }, { relationshipId, moduleId }) {
            // TODO show modal if there are not answered questions in results (128)

            console.log("finished");
            //const { status, response } = await api.postFinishModule({params: { relationshipId, moduleId }});
        },

        // teacher part
        async initModuleForm({ commit }, { disciplineId, moduleId }) {
            commit("setFetchStatus", {name: "GetInfo", status: "loading"});
            commit("setIds", { disciplineId, moduleId });

            const disciplines = await api.getDisciplines();

            if (disciplines.status !== 0) {
                console.error(disciplines.errors);
            } else {
                const name = disciplines.response.find(discipline => discipline.id === disciplineId).title;
                commit("setDisciplineName", name);
            }

            if (moduleId === "new") {
                commit("moduleEditForm/reset", {clearFields: true});
                commit("setFetchStatus", {name: "GetInfo", status: "ok"});
                return;
            }

            const { response, status, errors } = await api.getModuleInfo(disciplineId, moduleId);

            if (status !== 0) {
                console.error(errors);
            }

            commit("moduleEditForm/setData", {fields: {
                title: response.title,
                duration: response.duration,
            }});
            commit("setFetchStatus", {name: "GetInfo", status: "ok"});
        },
        async removeModule({ dispatch }, { disciplineId, moduleId }) {
            const { status, errors } = await api.deleteModule({ params: {disciplineId, moduleId} });

            if (status !== 0) {
                console.error(errors);
                return;
            }

            await dispatch("teacher/getDisciplinesList", {}, { root: true });
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
                commit("module/setFetchStatus", { name: "SaveInfo", status: "loading" }, { root: true });

                const params = {
                    disciplineId: rootState.module.disciplineId,
                    moduleId: rootState.module.moduleId
                };

                const body = {
                    title : getters['field']("title"),
                    duration : getters['field']("duration"),
                };

                const { status, errors } = (params.moduleId === "new") // do we create module or update
                    ? await api.postCreatedModule({ params, body })
                    : await api.postUpdatedModule({ params, body });

                if (status !== 0) {
                    console.error(errors);
                    return;
                }

                if (params.moduleId === "new") {
                    router.push(`/modules/teacher`);
                } else {
                    commit("module/setFetchStatus", { name: "SaveInfo", status: "ok" }, { root: true });
                }
            },
        }),
    }
};

export default module;
