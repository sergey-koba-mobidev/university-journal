<template>
    <form
        class="row Group__question"
    >
        <!-- TITLE -->
        <div class="Group__question-row">
            <div class="Group__question-label">Текст вопроса:</div>
            <div class="input-field Group__question-value text">
                <input type="text" v-model="text">
            </div>
            <!-- delete -->
            <i class="material-icons Group__question-delete">close</i>
        </div>
        <!-- KIND -->
        <div class="Group__question-row">
            <div class="Group__question-label">Тип вопроса:</div>
            <div class="Group__question-value">
                <label class="Group__question-valueLabel">
                    <input name="kind" type="radio" value="text"/>
                    <span> открытый </span>
                </label>
                <label class="Group__question-valueLabel">
                    <input name="kind" type="radio" value="one" v-model="kind"/>
                    <span> один вариант ответа </span>
                </label>
                <label class="Group__question-valueLabel" >
                    <input name="kind" type="radio" value="many" v-model="kind"/>
                    <span> несколько вариантов ответа </span>
                </label>
            </div>
        </div>
        <!-- VARIANTS -->
        <div class="Group__question-row" v-if="question.kind !== 'text'">
            <div class="Group__question-label">Варианты ответов:</div>
            <div>
                <variants
                    v-for="(variant, indexVariant) in variants"
                    :questionType="question.type"
                    :answer="answer"
                    :indexQuestion="question.index"
                    :indexVariant="indexVariant"
                    :variant="variant"
                />
                <button class="btn waves-effect waves-light Group__question-add" @click="addVariant">добавить вариант</button>
            </div>
        </div>
    </form>
</template>

<script>
    import { mapState, mapMutations, mapActions } from "vuex";
    import variants from "../components/GroupQuestionVariants";

    export default {
        name: "GroupQuestionsForm",
        props: {
            question: {
                type: Object,
                default: {}
            }
        },
        components: {
            variants,
        },
        computed: {
            ...mapState({
                field(_, getters) {
                    return getters[`${this.formName}/field`];
                },
            }),
            formName() {
                return `questionForm-${this.question.index}`
            },
            text: {
                get() {
                    return this.field("text");
                },
                set(value) {
                    this.changeField({ field: "text", value });
                },
            },
            kind: {
                get() {
                    return this.field("kind");
                },
                set(value) {
                    this.changeField({ field: "kind", value });
                },
            },
            variants: {
                get() {
                    return this.field("variants");
                },
                set(value) {
                    this.changeField({ field: "variants", value });
                },
            },
            answer: {
                get() {
                    return this.field("answer");
                },
                set(value) {
                    this.changeField({ field: "answer", value });
                },
            },
        },
        methods: {
            // ...mapMutations(["removeMember"]),
            ...mapActions({
                submit(dispatch, payload) {
                    return dispatch(
                        `${this.formName}/submit`,
                        payload
                    );
                },
                changeField(dispatch, payload) {
                    return dispatch(
                        `${this.formName}/changeField`,
                        payload
                    );
                },
            }),
            ...mapMutations({
                setData(commit, payload) {
                    return commit(
                        `${this.formName}/setData`,
                        payload
                    );
                }
            }),
            addVariant(e) {
                e.preventDefault();
                this.question.variants.push("");
            },
        },
        mounted() {
            this.setData({ fields: {
                text: this.question.text,
                kind: this.question.kind,
                variants: this.question.variants,
                answer: this.question.answer
            }});
        }
    }
</script>

<style lang="scss" scoped>
    .Group {
        &__question {
            border-bottom: 1px solid #827f7f;
            padding-bottom: 15px;
            margin-bottom: 35px;

            &-row {
                display: flex;
                margin-bottom: 1rem;
            }

            &-label {
                width: 23%;
                flex-shrink: 0;
            }

            &-value {
                flex-grow: 1;

                &.text {
                    margin-top: -10px;
                    margin-bottom: 0;

                    input {
                        border-bottom: 1px solid #cacaca;
                    }
                }

                &Label {
                    color: rgba(0,0,0,0.87);
                    display: flex;
                    justify-content: space-between;
                }
            }

            &-add {
                margin-top: 12px;
                background: #efefef;
                color: #1e887e;
                font-weight: 600;
                font-size: 14px;
                text-transform: lowercase;

                &.question {
                    max-width: 240px;
                    align-self: center;
                    margin-top: -1rem;
                    margin-bottom: 3rem;
                }
            }

            &-delete {
                color: #26a69a;
                transition: transform .3s;
                transform-origin: center;

                &:hover {
                    cursor: pointer;
                    transform: scale(1.1);
                }
            }
        }
    }
</style>
<style lang="scss">
</style>