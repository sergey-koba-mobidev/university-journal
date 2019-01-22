<template>
    <div class="Layout">
        <div class="Module container">
            <div class="Module__title">
                <div class="Module__title-discipline">{{ discipline }}</div>
                <div class="Module__title-module">{{ module }}</div>
            </div>
            <div class="Module__spinner" v-if="loading">
                <spinner class="Disciplines__spinner"/>
            </div>
            <template v-else>
                <div class="Module__timer">
                    Осталось времени:
                    <span class="Module__timer-number">
                        50:31
                    </span>
                </div>
                <form
                    class="Module__form"
                    novalidate
                    @submit.prevent=""
                >
                    <div
                        class="row Module__question"
                        :class="{'is-text': question.kind === 'text'}"
                        v-for="(question, index) in questions"
                    >
                        <div class="Module__question-index"> {{ index+1 }}. </div>

                        <div class="input-field Module__question-text" v-if="question.kind === 'text'">
                            <input id="question" type="text" @blur="handleAnswer(question.id, $event)">
                            <label for="question">{{ question.text }}</label>
                        </div>
                        <div v-else class="Module__question-text" @input="handleAnswer(question.id, $event)">
                            {{ question.text }}:
                            <p v-for="(variant, index) in question.variants">
                                <label>
                                    <input :name="question.id" :type="question.kind" :value="index"/>
                                    <span>{{ variant }}</span>
                                </label>
                            </p>
                        </div>
                    </div>
                    <div class="row Module__buttons">
                        <button
                            class="btn waves-effect waves-light modal-trigger"
                            type="submit"
                            name="action"
                            @click="openModuleModal"
                        >
                            ЗАВЕРШИТЬ
                        </button>
                        <button
                            class="btn waves-effect waves-light Module__buttons-back"
                            type="button"
                            name="action"
                            @click="handleBack()"
                        >
                            Назад
                        </button>
                    </div>
                </form>
            </template>
        </div>
        <modal @close="closeModuleModal" v-if="showModal">
            <div slot="header">Завершение</div>
            <div slot="body">
                <div>Вы уверены, что хотите завершить модуль?</div>
                <div>У Вас осталось <span class="Result__my">3</span> неотвеченных вопроса</div>
            </div>
        </modal>
    </div>
</template>

<script>
    import { mapState, mapMutations, mapActions } from 'vuex';
    import spinner from "../../public/spinner.svg";
    import modal from "../components/BaseModalWindow";

    export default {
        name: "Module",
        data() {
            return {
                id: this.$route.params.id,
                disciplineId: this.$route.params.disciplineId,
            }
        },
        components: {
            spinner,
            modal,
        },
        computed: {
            ...mapState({
                showModal: state => state.module.showModal,
                loading: state => state.module.fetchStatus === "init" ||
                         state.module.fetchStatus === "loading",
                questions: state => state.module.questions,
                discipline: state => state.module.discipline,
                module: state => state.module.module,
            }),
        },
        methods: {
            ...mapMutations(["closeModuleModal", "openModuleModal"]),
            ...mapActions(["getModule", "postAnswers"]),
            handleBack() {
                this.$router.push(`/modules/disciplines/`);
            },
            handleAnswer(questionId, event) {
                const answer = event.path[0].value;

                this.postAnswers({
                    disciplineId: +this.disciplineId,
                    moduleId: +this.id,
                    questionId,
                    answer
                });
            },
        },
        mounted() {
            this.getModule({disciplineId: this.disciplineId, moduleId: this.id});
        }
    }
</script>

<style lang="scss" scoped>
    .Layout {
        min-height: 100vh;
        background: rgba(162, 181, 179, .1);
        display: block;
    }

    .Module {
        padding: 2rem 0;

        &__title {
            text-align: center;

            &-discipline {
                font-weight: 500;
                font-size: 18px;
                margin-bottom: .5rem;
            }

            &-module {
                font-weight: 500;
                font-size: 20px;
                margin-bottom: 2rem;
            }
        }

        &__spinner {
            text-align: center;
        }

        &__timer {
            width: 70%;
            text-align: right;
            margin: 0 auto;
            padding-bottom: 10px;

            &-number {
                font-weight: 500;
            }
        }

        &__form {
            width: 70%;
            margin: 0 auto;
            box-shadow: 0 0 8px #d0c8c8;
            padding: .7rem 2rem;
            background: #fff;
        }

        &__question {
            display: flex;
            align-items: flex-start;

            &.is-text {
                align-items: center;
            }

            &-index {
                width: 30px;
            }

            &-text {
                flex-grow: 1;
                margin-top: 0;
            }
        }

        &__buttons {
            display: flex;
            flex-direction: column;

            &-back {
                margin-top: 1rem;
                background-color: #aebbba;
            }
        }
    }
</style>
