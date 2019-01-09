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
        async submitEditGroupForm({ state, commit, dispatch, getters }, { disciplineModuleId, id }) {
            dispatch("groupForm/submit", {payload: { disciplineModuleId, id}});

            let questions = [];

            for (let i in state.questionForms) {
                questions.push({
                    description:  getters[`questionForm-${i}/field`]("text"),
                    kind:  getters[`questionForm-${i}/field`]("kind"),
                    answer:  getters[`questionForm-${i}/field`]("answer"),
                    variants:  getters[`questionForm-${i}/field`]("variants"),
                });
            }

            console.log("post: ", questions);


            // postUpdateQuestion

            // api.postUpdateGroup

            // for (let i of state.members) {
            //     dispatch(`memberForm${i}/submit`);
            // }

            // const { errors } = await api.postCreateICO({ body });

            // if (errors) {
            //     console.error(errors);
            //     return;
            // }


            // TODO add redirecting
            // router.push(`/teacher`);
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
            async onSubmit({ rootState, commit, getters }, { disciplineModuleId, id }  ) {
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
