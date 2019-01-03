<template>
    <div class="Layout">
        <div class="CreateModule__title">
            Создать модуль для дисциплины
            <span  class="CreateModule__title-discipline">Web technologies and web design</span>
        </div>
        <div class="CreateModule">
            <form action="" class="CreateModule__form" @submit.prevent="submit({payload: {heading: 'createModuleForm'}})">
                <div class="row my-0">
                    <div class="input-field col s6 offset-s3 CreateModule__input my-0">
                        <input id="title" type="text" v-model="title">
                        <label for="title">Название</label>
                        <validation
                                :formKey="formKey"
                                field="title"
                        />
                    </div>
                </div>
                <div class="row my-0">
                    <div class="input-field col s6 offset-s3 CreateModule__input my-0">
                        <input id="duration" type="text" v-model="duration">
                        <label for="duration">Продолжительность</label>
                        <validation
                                :formKey="formKey"
                                field="duration"
                        />
                    </div>
                </div>
                <div class="row">
                    <button class="btn waves-effect waves-light CreateModule__btn_back" type="button" name="action">
                        <i class="large material-icons">chevron_left</i>
                        ВЕРНУТЬСЯ НАЗАД
                    </button>
                    <button class="btn waves-effect waves-light CreateModule__btn" type="submit" name="action">
                        СОЗДАТЬ
                    </button>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
    import validation from "../components/BaseValidationError";
    import { mapFieldsToComputed } from "../store/lib/vuex-form/index";

    export default
    {
        name: 'CreateModuleForm',
        data() {
            return {
                showModals: false,
                formKey: "createModuleForm",
            }
        },
        components: {
            validation,
        },
        computed: {
            ...mapFieldsToComputed("createModuleForm", [
                "title",
                "duration",
            ]),
        }
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

    .CreateModule{
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

            &_back {
                display: inline-flex;
                background: #cad0cf;
                margin-top: 2rem;
                margin-right: 1rem;
            }
        }
    }

    .my-0 {
        margin-top: 0 !important;
        margin-bottom: 0 !important;
    }
</style>
<style>
    .BaseValidationError {
        margin-top: -10px;
    }
</style>