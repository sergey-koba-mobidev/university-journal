<template>
    <div class="Variants">
        <label>
            <!--//:checked="question.answer.includes(indexVariant)"-->
            <input :name="'variant-'+indexQuestion" :type="questionType" :value="indexVariant" v-model="selectedVariant"/>
            <span>
                <input type="text" class="Variants__itemLabel" v-model="variantText">
            </span>
        </label>
        <i class="material-icons Variants__remove">close</i>
    </div>
</template>

<script>
    export default {
        name: "GroupQuestionVariants",
        props: {
            questionType: {
                type: String,
                default: ""
            },
            answer: {
                type: Number | Array,
                default: null
            },
            indexQuestion: {
                type: Number,
                default: null
            },
            indexVariant: {
                type: Number,
                default: null
            },
            variant: {
                type: String,
                default: ""
            }
        },
        computed: {
            selectedVariant: {
                get() {
                    return this.answer;
                },
                set(value) {
                    this.$emit('selectVariant', value)
                }
            },
            variantText: {
                get() {
                    return this.variant;
                },
                set(value) {
                    this.$emit('editVariant', this.indexVariant, value);
                }
            }
        },
    }
</script>

<style lang="scss" scoped>
    .Variants {
        flex-grow: 1;

        &__item {
            color: rgba(0,0,0,0.87);
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;

            &Label {
                height: 22px !important;
                margin-bottom: 0 !important;
            }
        }

        &__remove {
            color: #d4d4d4;
            transition: .3s;
            transform-origin: center;

            &:hover {
                cursor: pointer;
                color: #26a69a;
                transform: scale(1.1);
            }
        }
    }
</style>