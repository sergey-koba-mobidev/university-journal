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
                    <span class="Module__timer-number" :class="{'is-red': time <= 60}">{{ formattedTime }}</span>
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
                                    <input :name="question.id" :type="question.kind" :value="index" :disabled="disableAnswer"/>
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
        </div>с
        <modal
            v-if="showModal"
            @close="closeModuleModal"
            @handleOk="handleFinishModule"
        >
            <div slot="header">Завершение</div>
            <div slot="body">
                <div>Вы уверены, что хотите завершить модуль?</div>
                <div>У Вас остались неотвеченные вопросы</div>
            </div>
        </modal>
        <modal
            v-if="showFinishModal"
            @close="closeModuleModal(true)"
        >
            <div slot="header">Завершение</div>
            <div slot="body">
                <div>Завершить модуль?</div>
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
                relationshipId: this.$route.params.relationshipId,
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
                showFinishModal: state => state.module.showFinishModal,
                loading: state => state.module.fetchGetModuleStatus === "init" ||
                         state.module.fetchGetModuleStatus === "loading",
                questions: state => state.module.questions,
                discipline: state => state.module.discipline,
                module: state => state.module.module,
                msTime: state => state.module.time,
                finishedModule: state => state.module.finishModule,
            }),
            time: {
                get() {
                    return this.msTime;
                },
                set(value) {
                    this.setModuleTime(value);
                }
            },
            formattedTime() {
                if (this.time <= 0) {
                    return "00 : 00";
                }

                const min = parseInt(this.time/60);
                const sec = this.time % 60;
                const mm = min <= 9 ? `0${min}` : min;
                const ss = sec <= 9 ? `0${sec}` : sec;

                return `${mm} : ${ss}`;
            },
            disableAnswer() {
                return this.msTime <= 0 || this.finishedModule;
            }
        },
        methods: {
            ...mapMutations("module", ["closeModuleModal", "setModuleTime", "setFinishModule", "openModuleModal"]),
            ...mapActions("module", ["getModule", "postAnswers", "finishModule"]),
            handleBack() {
                this.$router.push(`/modules/disciplines/`);
            },
            handleAnswer(questionId, event) {
                const answer = event.path[0].value;

                this.postAnswers({
                    relationshipId: +this.relationshipId,
                    disciplineId: +this.disciplineId,
                    moduleId: +this.id,
                    questionId,
                    answer
                });
            },
            startTimer() {
                const that = this;
                const timerId = setTimeout(function timer() {
                    if (that.time <= 0) {
                        that.time = 0;
                        clearTimeout(timerId);
                        return;
                    }

                    that.time--;

                    setTimeout(timer, 1000);
                }, 1000);
            },
            handleFinishModule() {
                this.finishModule({relationshipId: this.relationshipId, disciplineId: this.disciplineId});
            }
        },
        mounted() {
            this.getModule({disciplineId: this.disciplineId, moduleId: this.id});

            this.startTimer();
        },
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

                &.is-red {
                    color: #E2002B;
                }
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
