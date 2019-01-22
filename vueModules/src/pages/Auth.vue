<template>
    <div class="Welcome container">
        <form
            class="center-align Welcome__form"
            novalidate
            @submit.prevent="submit({payload: {heading: 'Auth'}, meta: {}})"
        >
            <div class="row mb-0">
                <div class="input-field col s6 offset-s3 Welcome__input">
                    <input id="email" type="text" v-model="email">
                    <label for="email">E-mail</label>
                    <validation
                        :formKey="formKey"
                        field="email"
                    />
                </div>
            </div>
            <div class="row">
                <div class="input-field col s6 offset-s3 Welcome__input">
                    <input id="password" type="password" v-model="password">
                    <label for="password">Пароль</label>
                    <validation
                        :formKey="formKey"
                        field="password"
                    />
                </div>
            </div>
            <div class="row">
                <button class="btn waves-effect waves-light Welcome__btn" type="submit" name="action">Войти</button>
            </div>
        </form>
    </div>
</template>

<script>
    import { mapActions } from "vuex";
    import { mapFieldsToComputed } from "../store/lib/vuex-form/index";
    import validation from "../components/BaseValidationError";

    export default {
        name: 'Auth',
        data() {
            return {
                formKey: "authForm",
            }
        },
        components: {
            validation,
        },
        computed: {
            ...mapFieldsToComputed("authForm", [
                "email",
                "password",
            ]),
        },
        methods: {
            ...mapActions("authForm", ["submit"]),
        },
        mounted() {
        },
    }
</script>

<style lang="scss" scoped>
    .Welcome {
        height: 100vh;
        display: flex;
        flex-direction: column;
        justify-content: center;

        &__form {
            width: 60%;
            padding-top: 3rem;
            padding-bottom: 2rem;
            margin: -1rem auto 0;
            background: rgba(255, 255, 255, 0.9);
            box-shadow: 0 0 18px #4c4c4c;
        }

        &__input {
            margin-top: 0;
            margin-bottom: 0;
        }

        input:-webkit-autofill {
             background: transparent;
        }

        .mb-0 {
            margin-bottom: 0;
        }

        &__btn {
            margin-top: 1rem;
        }
    }
</style>

<style lang="scss">
    #app {
        background: url("../assets/Auth-bg.jpg") center;
        background-size: cover;
    }

    .BaseValidationError {
        margin-top: -10px;
    }
</style>
