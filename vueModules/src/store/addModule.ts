import { Module } from "vuex";
import api from "./lib/api";
import { Form, required } from "./lib/vuex-form";
import router from "../main";

export interface AddModuleState {
    fetchStatus: FetchStatus;
    disciplines: String[];
}

const module: Module<AddModuleState, {}> = {
    state: {
        fetchStatus: "init",
        disciplines: []
    },
    mutations: {
        setFetchStatus(state, status: FetchStatus) {
            state.fetchStatus = status;
        },
        setDisciplines(state, disciplines) {
            state.disciplines = disciplines;
        }
    },
    actions: {
        async getDisciplinesList({ commit, dispatch }) {
            commit("setFetchStatus", "loading");

            const {status, response, errors} = await api.getDisciplines();

            if (status !== 0) {
                console.error(errors);
            }

            const disciplines = [];

            for (let item of response) {
                const modules = await dispatch("getCreatedModules", item.id);

                disciplines.push({
                    name: item.title,
                    id: item.id,
                    modules
                });
            }

            localStorage.setItem("disciplines", JSON.stringify(disciplines));

            commit("setDisciplines", disciplines);
            commit("setFetchStatus", "ok");
        },
        async getCreatedModules({}, disciplineId) {
            const { status, response, errors} = await api.getCreatedModules(disciplineId);

            if (status !== 0) {
                console.error(errors);
            }

            return response
                .map(module => ({
                    title: module.title,
                    id: module.id,
                    duration: module.duration
                }));
        },
        async createModule({ commit }, disciplineId) {
            // const { status, response, result } = api.postCretaeModule({
            //     params: {
            //         disciplineId
            //     },
            //     body
            // });
        }
    },
    modules: {
        createModuleForm: new Form({
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
                    ],
                },
            },
            async onSubmit({ commit, getters }) {

            },
        }),
    }
};

export default module;
