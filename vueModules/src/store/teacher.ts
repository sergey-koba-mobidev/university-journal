import { Module } from "vuex";
import api from "./lib/api";
import { Form, required } from "./lib/vuex-form";
import router from "../main";

export interface TeacherState {
    fetchStatus: FetchStatus;
    disciplines: String[];
}

const module5: Module<TeacherState, {}> = {
    namespaced: true,
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

            return response.map(module => ({
                title: module.title,
                id: module.id,
                duration: module.duration
            }));
        },
    },
};

export default module5;
