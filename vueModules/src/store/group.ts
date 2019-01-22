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
        async submitQuestionForms({ state, dispatch, getters }) {
            for (let i in state.questionForms) {
                dispatch(`questionForm-${i}/submit`);
            }

            for (let i in state.questionForms) {
                // TODO rewrite localStorage with state
                const params = {
                    questionGroupId: JSON.parse(localStorage.getItem("selectedGroup")).groupId,
                    id: getters[`questionForm-${i}/field`]("id"),
                };

                const body = {
                    description:  getters[`questionForm-${i}/field`]("text"),
                    kind:  getters[`questionForm-${i}/field`]("kind") === "many"
                                ? 2
                                : getters[`questionForm-${i}/field`]("kind") === "one"
                                    ? 1
                                    : 0,
                    answer:  getters[`questionForm-${i}/field`]("answer"),
                    variants:  getters[`questionForm-${i}/field`]("variants"),
                };

                const { errors } = params.id
                    ? await api.postUpdateQuestion({ params, body })
                    : await api.postCreateQuestion({ params, body });

                if (errors) {
                    console.error(errors);
                    return;
                }
            }

            router.push(`/modules/teacher`);
        },
        async deleteQuestion({ getters }, id) {
            const params = {
                questionGroupId: JSON.parse(localStorage.getItem("selectedGroup")).groupId,
                id: id,
            };

            const { errors }= await api.deleteQuestion({ params });
        }
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
            async onSubmit({ rootState, commit, dispatch, getters }, { disciplineModuleId, id }  ) {
                const params = { disciplineModuleId, id };

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

                dispatch("submitQuestionForms", {}, {root: true});
            },
        }),
    }
};

import store from './../store';

function createNewForm(formName: string) {
    store.registerModule(formName, new Form({
        fields: {
            id: {
                type: Number,
            },
            text: {
                type: String,
                validators: [
                    required(),
                ],
            },
            kind: {
                type: String,
                validators: [
                    required()
                ],
            },
            variants: {
                type: String,
                validators: [
                    required()
                ],
            },
            answer: {
                type: String,
                validators: [
                    // required()
                ],
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
