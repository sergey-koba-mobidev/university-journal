<template>
    <div class="Group">
        <div class="Group__form">
            <form>
                <div class="Group__title">
                    <div class="Group__title-discipline">Web technologies and web design</div>
                </div>
                <div v-if="groupLoading" class="text-center">
                    <spinner class="Block__spinner"/>
                </div>
                <div v-else class="Group__info">
                    <div class="Group__info-row">
                        <div class="Group__info-label">Название группы</div>
                        <div class="flex-grow-1">
                            <input type="text" v-model="title" class="Group__info-value">
                            <validation formKey="groupForm" field="title"/>
                        </div>
                    </div>
                    <div class="Group__info-row">
                        <div class="Group__info-label">Позиция</div>
                        <div class="flex-grow-1">
                            <input type="text" v-model="position" class="Group__info-value">
                            <validation formKey="groupForm" field="position"/>
                        </div>
                    </div>
                    <div class="Group__info-row">
                        <div class="Group__info-label">Количество баллов</div>
                        <div class="flex-grow-1">
                            <input type="text" v-model="points" class="Group__info-value">
                            <validation formKey="groupForm" field="points"/>
                        </div>
                    </div>
                </div>
            </form>
            <!-- QUESTIONS -->
            <div class="Group__title-questions">Список вопросов: </div>
            <div v-if="questionLoading" class="text-center">
                <spinner class="Block__spinner"/>
            </div>
            <GroupQuestionsForm v-else :question="question" v-for="question of questionForms" :key="question.randomKey"/>
            <!-- BUTTONS -->
            <div class="Group__buttons">
                <button
                    class="btn waves-effect waves-light Group__buttons-add question"
                    @click="addQuestionForm"
                >
                    добавить еще один вопрос
                </button>
                <button
                    class="btn waves-effect waves-light Group__buttons-save"
                    type="submit"
                    @click="submit"
                >
                    <div v-if="saving">
                        <spinner/>
                    </div>
                    <template v-else> СОХРАНИТЬ ИЗМЕНЕНИЯ </template>
                </button>
                <button
                    class="btn waves-effect waves-light Group__buttons-back"
                    type="button"
                    name="action"
                    @click="handleBack"
                >
                    Назад
                </button>
            </div>
        </div>
    </div>
</template>

<script>
    import { mapState, mapMutations, mapActions } from "vuex";
    import spinner from "../../public/spinner.svg";
    import BaseCollapse from "../components/BaseCollapse";
    import GroupQuestionsForm from "../components/QuestionForm";
    import modal from "../components/BaseModalWindow";
    import validation from "../components/BaseValidationError";
    import { mapFieldsToComputed } from "../store/lib/vuex-form/index";

    export default {
        name: "Group",
        components: {
            spinner,
            BaseCollapse,
            modal,
            validation,
            GroupQuestionsForm
        },
        data() {
            return {
                groupId: parseInt(this.$route.params.groupId),
                disciplineModuleId: parseInt(this.$route.params.disciplineModuleId),
                newKind: ''
            }
        },
        computed: {
            ...mapState({
                questionForms: state => state.group.questionForms,
                groupLoading: state => state.group.fetchGroupStatus === "init" || state.group.fetchGroupStatus === "loading",
                questionLoading: state => state.group.fetchQuestionsStatus === "init" || state.group.fetchQuestionsStatus === "loading",
                saving: state => state.group.fetchSaveStatus === "loading",
            }),
            ...mapFieldsToComputed("groupForm", [
                "title",
                "position",
                "points",
            ]),
        },
        methods: {
            ...mapMutations(["addQuestionForm"]),
            ...mapActions(["initGroup"]),
            ...mapActions("groupForm", ["submit"]),
            handleBack() {
                this.$router.push(`/modules/teacher`);
            }
        },
        mounted() {
            this.initGroup({
                disciplineModuleId: this.disciplineModuleId,
                groupId: this.groupId
            });
        }
    }
</script>

<style lang="scss" scoped>
    .flex-grow-1 {
        flex-grow: 1;
    }
    .text-center {
        text-align: center;
    }

    .Group {
        min-height: 100vh;
        background: #efefef;
        display: flex;
        align-items: center;
        justify-content: center;

        &__info {
            border-bottom: 2px solid #827f7f;
            padding: 10px 20px;
            margin-top: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 0 1px #4e4e4e;

            &-row {
                display: flex;
                margin-bottom: 7px;
            }

            &-label {
                width: 30%;
                flex-shrink: 0;
            }

            &-value {
                flex-grow: 1;
                margin-top: -4px !important;
                height: 2rem !important;
                border-bottom: 1px solid #cacaca !important;
            }
        }

        &__title {
            text-align: center;

            &-discipline {
                font-weight: 500;
                font-size: 18px;
                margin-bottom: .5rem;
            }

            &-questions {
                font-weight: 500;
                font-size: 16px;
                margin-bottom: 3rem;
                text-transform: uppercase;
                text-align: center;
            }
        }

        &__form {
            background: #fff;
            box-shadow: 0 0 8px #d0c8c8;
            width: 50%;
            margin: 0 auto;
            padding: 2rem 2rem;
        }

        &__buttons {
            display: flex;
            flex-direction: column;
            width: 70%;
            margin: 0 auto;

            &-back {
                margin-top: 1rem;
                background-color: #aebbba;
            }

            &-save {
                svg {
                    width: 40px;
                    height: 40px;
                    margin-top: -3px;
                }

                path {
                    fill: #fff;
                }
            }

            &-add {
                background: #efefef;
                color: #1e887e;
                font-weight: 600;
                font-size: 14px;
                text-transform: lowercase;
                max-width: 240px;
                align-self: center;
                margin-top: -1rem;
                margin-bottom: 3rem;
            }
        }

        .BaseValidationError {
            margin-top: -15px;
        }
    }
</style>
