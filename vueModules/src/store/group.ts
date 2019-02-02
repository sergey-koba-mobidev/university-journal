import { Module } from "vuex";
import api from "./lib/api";
import { Form, required } from "./lib/vuex-form/index";
import router from "../main";

type questionFormsType = {
    index: number;
    existedQuestion?: object;
}

export interface GroupState {
    fetchGroupStatus: FetchStatus;
    questions: String[];
    questionForms: questionFormsType[];
}

const module: Module<GroupState, {}> = {
    state: {
        fetchGroupStatus: "init",
        questions: [],
        questionForms: [],
    },
    mutations: {
        addQuestionForm(state, existedQuestion) { //TODO: rewrite without 0
            if (!state.questionForms.length) {
                state.questionForms.push({
                    index: 0,
                    ...existedQuestion
                });

                const formName = `questionForm-0`;
                createNewForm(formName);
            } else {
                const lastItem = state.questionForms[state.questionForms.length-1];

                state.questionForms.push({
                    index: lastItem.index + 1,
                    ...existedQuestion
                });

                const formName = `questionForm-${lastItem.index + 1}`;

                createNewForm(formName);
            }
        },
        setGroupFetchStatus(state, status: FetchStatus) {
            state.fetchGroupStatus = status;
        },
        setQuestions(state, questions) {
            state.questions = questions;
        }
    },
    actions: {
        initGroup({ rootState, commit, dispatch }) {
            const groupId = JSON.parse(localStorage.getItem("selectedGroup")).groupId;

            const group = rootState["questionsGroup"].groups[groupId];

            commit("groupForm/setData", {fields: {
                title: group.title,
                position: group.position,
                points: group.points
            }});

            dispatch("getQuestionList", groupId);
        },
        async getQuestionList({ commit, dispatch }, groupId) {
            commit("setGroupFetchStatus", "loading");

            const {status, response, errors} = await api.getGroupQuestions(groupId);

            if (status !== 0) {
                console.error(errors);
            }

            const questions = response.map(q => {
                const answer = q.kind === "text"
                                ? ""
                                : q.kind === "one"
                                    ? q.answer
                                    : q.answer.slice(1, -1).split(",").map(a => +a);
                const result = {
                    text: q.description,
                    id: q.id,
                    questionGroupId: q.question_group_id,
                    kind: q.kind,
                    type: q.kind === "text"
                        ? "text"
                        : q.kind === "one"
                            ? "radio"
                            : "checkbox",
                    variants: q.variants,
                    answer
                };

                commit("addQuestionForm", result);

                return result;
            });

            commit("setQuestions", questions);
            commit("setGroupFetchStatus", "ok");
        },
        async submitForm({ state, commit, dispatch, getters }) {
            dispatch("groupForm/submit");

            // for (let i of state.members) {
            //     dispatch(`memberForm${i}/submit`);
            // }

            // const { errors } = await api.postCreateICO({ body });

            // if (errors) {
            //     console.error(errors);
            //     return;
            // }
        },
    },
    modules: {
        groupForm: new Form({
            throttle: 300,
            fields: {
                title: {
                    type: String,
                    validators: [
                        required(),
                    ],
                },
                position: {
                    type: String,
                    validators: [
                        required(),
                    ],
                },
                points: {
                    type: String,
                    validators: [
                        required(),
                    ],
                },
            },
            async onSubmit({ commit, getters }, { disciplineModuleId, id }) {
                const params = {  disciplineModuleId, id };

                const body = {
                    title : getters['field']("title"),
                    position : getters['field']("position"),
                    points : getters['field']("points"),
                };

                const { errors } = await api.postUpdateGroup({ params, body });

                if (errors) {
                    console.error(errors);
                    return
                }

                router.push(`/modules/teacher`);
            },
        }),
    }
};

import store from './../store';

function createNewForm(formName: string) {
    store.registerModule(formName, new Form({
        fields: {
            text: {
                type: String,
                validators: [],
            },
            kind: {
                type: String,
                validators: [],
            },
            variants: {
                type: String,
                validators: [],
            },
            answer: {
                type: String,
                validators: [],
            },
        },
        onSubmit({ commit, getters }) {
        },
    }));
}

export function removeForm(this: any, formName: string) {
    this.$store.unregisterModule(formName);
}

export default module;
