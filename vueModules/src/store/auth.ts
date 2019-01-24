import { Module } from "vuex";
import { email, Form, required } from "./lib/vuex-form";
import api from "./lib/api";
import router from "../main";

export interface AuthState {
    fetchStatus: FetchStatus;
    email: string;
    name: string;
}

const module: Module<AuthState, {}> = {
    state: {
        fetchStatus: "init",
        email: "",
        name: "",
    },
    mutations: {
        setFetchStatus(state, status: FetchStatus) {
            state.fetchStatus = status;
        },
        setUserData(state, {email, name}) {
            state.email = email;
            state.name = name;
        },
    },
    actions: {
        logoutUser({ commit }) {
            commit("setUserData", {email: "", name: ""});
            localStorage.removeItem("logined");
            localStorage.removeItem("user");
            localStorage.removeItem("token");

            router.push("/modules/auth");
        }
    },
    modules: {
        authForm: new Form({
            throttle: 300,
            fields: {
                email: {
                    type: String,
                    validators: [
                        required(),
                        email(),
                    ],
                },
                password: {
                    type: String,
                    validators: [
                        required(),
                    ],
                },
            },
            async onSubmit({ commit, getters }) {
                commit("setFetchStatus", "loading");

                const body = {
                    email : getters['field']("email"),
                    password : getters['field']("password"),
                };

                const  { status, response, errors }  = await api.postSignIn({body});

                if (status !== 0) {
                    console.error(errors.body);
                    commit("setErrors", {errors: errors.body});
                    return;
                }

                const settings = {
                    email: response.email,
                    name: response.name,
                    role: response.role
                };

                localStorage.setItem('token', response.api_token);
                localStorage.setItem('logined', "true");
                localStorage.setItem('user', JSON.stringify(settings));

                commit("setUserData", {email: response.email, name: response.name}, {root: true});

                const path = response.role === "student" ? "/modules/disciplines" : "/modules/teacher";

                const redirect = router.currentRoute.query.redirect;

                router.push({
                    path,
                    query: {
                        redirect,
                    },
                });
                    // router.push({path: path});



                commit("setFetchStatus", "ok");
            },
        }),
    }
};

export default module;
