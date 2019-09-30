<template>
    <div class="Layout">
        <div class="CreateGroup__title">
            Создать группу вопросов для модуля
            <span class="CreateGroup__title-discipline">{{ discipline }}</span>
        </div>
        <div class="CreateGroup">
            <div v-if="loading">
                <spinner/>
            </div>
            <form v-else class="CreateGroup__form" @submit.prevent="submit">
                <div class="row my-0">
                    <div class="input-field col s6 offset-s3 CreateGroup__input my-0">
                        <input id="title" type="text" v-model="title">
                        <label for="title" :class="{'active': title}">Название</label>
                        <validation :formKey="formKey" field="title"/>
                    </div>
                </div>
                <div class="row my-0">
                    <div class="input-field col s6 offset-s3 CreateGroup__input my-0">
                        <input id="position" type="text" v-model="position">
                        <label for="position" :class="{'active': position}">Позиция</label>
                        <validation :formKey="formKey" field="position"/>
                    </div>
                </div>
                <div class="row my-0">
                    <div class="input-field col s6 offset-s3 CreateGroup__input my-0">
                        <input id="points" type="text" v-model="points">
                        <label for="points" :class="{'active': points}">Количество баллов</label>
                        <validation :formKey="formKey" field="points"/>
                    </div>
                </div>
                <div class="row">
                    <button
                        class="btn waves-effect waves-light CreateGroup__btn_back"
                        type="button"
                        name="action"
                        @click="handleBack"
                    >
                        <i class="large material-icons">chevron_left</i>
                        ВЕРНУТЬСЯ НАЗАД
                    </button>
                    <button class="btn waves-effect waves-light CreateGroup__btn" type="submit" name="action">
                        <spinner v-if="saving" class="CreateGroup__btn-spinner"/>
                        <span v-else>СОХРАНИТЬ</span>
                    </button>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
    import validation from "../components/BaseValidationError";
    import { mapFieldsToComputed } from "../store/lib/vuex-form/index";
    import { mapState, mapActions } from "vuex";
    import spinner from "../../public/spinner.svg";

    export default
    {
        name: 'CreateGroupForm',
        data() {
            return {
                formKey: "createGroupForm",
                disciplineId: parseInt(this.$route.params.disciplineId),
                moduleId: parseInt(this.$route.params.moduleId),
            }
        },
        components: {
            validation,
            spinner,
        },
        computed: {
            ...mapState({
                loading: state => state.module.fetchGetInfoStatus === "loading",
                saving: state => state.module.fetchSaveInfoStatus === "loading",
                discipline: state => state.module.discipline
            }),
            ...mapFieldsToComputed("createGroupForm", [
                "title",
                "position",
                "points"
            ]),
        },
        methods: {
            ...mapActions("module", ["initModuleForm"]),
            ...mapActions("createGroupForm", ["submit"]),
            handleBack() {
                this.$router.push(`/modules/teacher`);
            },
        },
        beforeMount() {
            this.initModuleForm({
                disciplineId: this.disciplineId,
                moduleId: this.moduleId
            });
        },
    }
</script>

<style lang="scss" scoped>
    .Layout {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100vh;
        background: url("../assets/CreateModule-bg.jpg") center;
        background-size: cover;
    }

    .CreateGroup{
        width: 50%;
        padding-top: 2rem;
        background: rgba(255, 255, 255, 0.7);
        box-shadow: 0 0 8px 0 rgba(111, 111, 111, 0.7);
        border: 2px solid #b9ab9d;
        text-align: center;

        &__title {
            width: 50%;
            color: #51716e;
            text-shadow: -5px 1px 15px #c1c1c1;
            margin-bottom: 4px;
            background: rgba(255, 255, 255, 0.7);
            box-shadow: 0 0 8px 0 rgba(111, 111, 111, 0.7);
            border: 2px solid #b9ab9d;
            padding-left: 1rem;
            padding-right: 1rem;

            &-discipline {
                font-weight: 600;
            }
        }

        &__btn {
            margin-top: 2rem;
            min-width: 116px;

            &_back {
                display: inline-flex;
                background: #cad0cf;
                margin-top: 2rem;
                margin-right: 1rem;
            }

            &-spinner {
                height: 100%;

                path {
                    fill: #fff;
                }
            }
        }
    }

    .my-0 {
        margin-top: 0 !important;
        margin-bottom: 0 !important;
    }
</style>
<style>
    .CreateGroup {
        .BaseValidationError {
            margin-top: -10px;
        }
    }
</style>
