import { Module } from "vuex";
import api from "./lib/api";

type QuestionType = {
    id: number;
    text: string;
    variants: string[];
    kind: string;
}

export interface ModuleState {
    fetchStatus: FetchStatus;
    questions: QuestionType;
    discipline: string;
    module: string;
    showModal: Boolean;
}

const module: Module<ModuleState, {}> = {
    state: {
        fetchStatus: "init",
        questions: {} as QuestionType,
        discipline: "",
        module: "",
        showModal: false,
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
        }
    },
};

export default module;
