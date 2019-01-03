import { Module } from "vuex";
import api from "./lib/api";

export interface QuestionsGroupState {
    fetchGroupsStatus: FetchStatus;
    groups: String[];
}

const module: Module<QuestionsGroupState, {}> = {
    state: {
        fetchGroupsStatus: "init",
        groups: []
    },
    mutations: {
        setGroupsFetchStatus(state, status: FetchStatus) {
            state.fetchGroupsStatus = status;
        },
        setGroups(state, groups) {
            state.groups = groups;
        }
    },
    actions: {
        async getGroupList({ commit, dispatch }, moduleId) {
            commit("setGroupsFetchStatus", "loading");

            const {status, response, errors} = await api.getQuestionGroups(moduleId);

            if (status !== 0) {
                console.error(errors);
            }

            const groups = {};
            for (let group of response) {
                groups[group.id] = {
                    disciplineModuleId: group.discipline_module_id,
                    points: group.points,
                    position: group.position,
                    title: group.title
                }
            }

            commit("setGroups", groups);
            commit("setGroupsFetchStatus", "ok");
        },
    },
    modules: {

    }
};

export default module;
