import { Module } from "vuex";
import api from "./lib/api";
import {custom, Form, required} from "./lib/vuex-form/index";
import router from "../main";

export interface GroupState {
    fetchGroupsStatus: FetchStatus;
    fetchGroupStatus: FetchStatus;
    fetchSaveStatus: FetchStatus;
    fetchQuestionsStatus: FetchStatus;
    groups: String[];
    disciplineModuleId: number| null;
    groupId: number | null;
    questions: String[];
    questionForms: Object;
}

const module3: Module<GroupState, {}> = {
    state: {
        fetchGroupsStatus: "init",
        fetchGroupStatus: "init",
        fetchSaveStatus: "init",
        fetchQuestionsStatus: "init",
        groups: [],
        disciplineModuleId: null,
        groupId: null,
        questions: [],
        questionForms: {},
    },
    mutations: {
        addQuestionForm(state, existedQuestion) {
            const lastItem = state.questionForms[Object.keys(state.questionForms).length-1];
            const index = lastItem === undefined ? 0 : lastItem.index + 1;
            const randomKey = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
            state.questionForms[index] = {
                index,
                randomKey,
                ...existedQuestion
            };

            createNewForm(`questionForm-${index}`);
        },
        removeQuestionForm(state, index) {
            delete state.questionForms[index];
        },
        removeAllQuestionForms(state) {
          state.questionForms = {}
        },
        setGroupFetchStatus(state, { name, status }) {
            state[`fetch${name}Status`] = status;
        },
        setGroups(state, groups) {
            state.groups = groups;
        },
        setQuestions(state, questions) {
            state.questions = questions;
        },
        setIds(state, { disciplineModuleId, groupId }) {
            state.disciplineModuleId = disciplineModuleId;
            state.groupId = groupId;
        }
    },
    actions: {
        async initGroup({ rootState, commit, dispatch }, { disciplineModuleId, groupId }) {
            commit("setGroupFetchStatus", { name: "Group", statur: "loading"});

            const { response, errors } = await api.getGroupData(disciplineModuleId, groupId);

            if (errors) {
                console.error(errors);
                return;
            }

            commit("setIds", { disciplineModuleId, groupId });

            commit("groupForm/setData", {fields: {
                title: response.title,
                position: response.position,
                points: response.points
            }});

            commit("setGroupFetchStatus", { name: "Group", statur: "ok"});
            dispatch("getQuestionList", groupId);
        },
        async getGroupsList({ commit, dispatch }, moduleId) {
            commit("setGroupFetchStatus", { name: "Groups", status: "loading"});

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
            commit("setGroupFetchStatus", { name: "Groups", status: "ok"});
        },
        async getQuestionList({ commit, dispatch }, groupId) {
            commit("setGroupFetchStatus", { name: "Questions", statur: "loading"});

            const {status, response, errors} = await api.getGroupQuestions(groupId);

            if (status !== 0) {
                console.error(errors);
            }
            commit("removeAllQuestionForms");
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
            commit("setGroupFetchStatus", { name: "Questions", status: "ok"});
        },
        async submitQuestionForms({ state, commit, dispatch, getters }) {
            for (let i in state.questionForms) {
                dispatch(`questionForm-${i}/submit`);
            }

            for (let i in state.questionForms) {
                if (!getters[`questionForm-${i}/dirty`]) {
                    continue;
                }

                const params = {
                    groupId: state.groupId,
                    id: getters[`questionForm-${i}/field`]("id"), // just created question doesn't have id
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
                }
            }

            commit("setGroupFetchStatus", { name: "Save", status: "ok"});
            // router.push(`/modules/teacher`);
        },
        async deleteQuestion({ state, commit, getters }, { formName, questionId }) {
            commit("removeQuestionForm", formName.split("-")[1] );
            removeForm(formName);

            if (questionId === undefined) {
                return;
            }

            const { errors } = await api.deleteQuestion({ params: {
                groupId: state.groupId,
                id: questionId,
            }});

            if (errors) {
                console.error(errors);
            }
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
            async onSubmit({ rootState, commit, dispatch, getters }) {
                commit("setGroupFetchStatus", { name: "Save", status: "loading" }, { root: true });

                if (!getters['dirty']) {
                    dispatch("submitQuestionForms", {}, { root: true });
                    return;
                }

                const params = {
                    disciplineModuleId: rootState.group.disciplineModuleId,
                    id: rootState.group.groupId
                };

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

                dispatch("submitQuestionForms", {}, { root: true });
            },
        }),
        createGroupForm: new Form({
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
          async onSubmit({ rootState, commit, dispatch, getters }) {
              commit("setGroupFetchStatus", { name: "Save", status: "loading" }, { root: true });

              const params = {
                  disciplineModuleId: rootState.group.disciplineModuleId,
                  id: rootState.group.groupId
              };

              const body = {
                  title : getters['field']("title"),
                  position : getters['field']("position"),
                  points : getters['field']("points"),
              };

              const { errors } = await api.postCreateGroup({ params, body });
              commit("setGroupFetchStatus", { name: "Save", status: "ok" }, { root: true });

              if (errors) {
                  console.error(errors);
                  return
              }
          },
        }),
    }
};

import store from './../store';

function createNewForm(formName: string) {
    if (Object.keys(store.getters).includes(`${formName}/loading`)) {
      return;
    }
    store.registerModule(formName, new Form({
        throttle: 300,
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
                    custom((variants) => {
                        if (!variants) {
                            // TODO check if kind is not "text"
                            return;
                        }
                        for (let variant of variants) {
                            if (!variant) {
                                return "Все варианты должны быть введены!";
                            }
                        }
                    }),
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

function removeForm(this: any, formName: string) {
    store.unregisterModule(formName);
}

export default module3;
