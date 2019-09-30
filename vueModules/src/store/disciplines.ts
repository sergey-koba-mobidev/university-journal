import { Module } from "vuex";
import api from "./lib/api";

type DisciplineType = {
    name: string;
    id: number;
    modules: any;
    relationshipId: number;
};

export interface DisciplinesState {
    fetchStatus: FetchStatus;
    disciplines: DisciplineType[];
}

const module: Module<DisciplinesState, {}> = {
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
        async getDisciplines({ commit, dispatch }) {
            commit("setFetchStatus", "loading");

            const { status, response, errors } = await api.getRelationships();

            if (status !== 0) {
                console.error(errors);
            }

            const disciplines = [];

            for (let item of response) {
                const modules = await dispatch("getModules", item.discipline.id);

                disciplines.push({
                    name: item.discipline.title,
                    id: item.id,
                    modules,
                    relationshipId: item.id,
                });
            }

            localStorage.setItem("disciplines", JSON.stringify(disciplines));

            commit("setDisciplines", disciplines);
            commit("setFetchStatus", "ok");
        },
        async getModules({}, disciplineId) {
            const { status, response, errors} = await api.getModules(disciplineId);

            if (status !== 0) {
                console.error(errors);
            }

            return response
                .filter(module => module.enabled)
                .map(module => ({
                    title: module.title,
                    id: module.id
                }));
        },
    },
};

export default module;
