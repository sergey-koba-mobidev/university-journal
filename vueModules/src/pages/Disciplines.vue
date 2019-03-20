<template>
    <div class="Layout">
        <div class="Disciplines__you">
            <div>
                Вы зашли под именем
                <span  class="Disciplines__you-name">{{ name }}</span>
            </div>
            <div class="Disciplines__logout" @click="logoutUser">Выйти</div>
        </div>
        <div class="Disciplines container">
            <div class="Disciplines__title">Выберите дисциплину: </div>
            <div class="Disciplines__wrap" >
                <spinner class="Disciplines__spinner" v-if="loading"/>
                <BaseCollapse
                    v-for="(discipline, index) in disciplines"
                    :index="index + 1"
                    :key="index"
                    v-else
                >
                    <div slot="header">
                        <a class="waves-effect waves-light btn Disciplines__discipline"> {{ discipline.name }} </a>
                    </div>
                    <div slot="content">
                        <a
                            v-for="module in discipline.modules"
                            class="Disciplines__module"
                            @click="handleShowModule(discipline.relationshipId, discipline.id, module.id)"
                        >
                            {{ module.title }}
                        </a>
                    </div>
                </BaseCollapse>
            </div>
        </div>
    </div>
</template>

<script>
    import { mapState, mapActions } from "vuex";
    import spinner from "../../public/spinner.svg";
    import BaseCollapse from "../components/BaseCollapse";

    export default {
        name: 'Discipline',
        components: {
            spinner,
            BaseCollapse,
        },
        computed: {
            ...mapState({
                name: state => state.auth.name || JSON.parse(localStorage.getItem('user')).name,
                disciplines: state => state.disciplines.disciplines,
                loading: state => state.disciplines.fetchStatus === "init" ||
                         state.disciplines.fetchStatus === "loading",
            }),
        },
        methods: {
            ...mapActions(["getDisciplines", "logoutUser"]),
            handleShowModule(relationshipId, disciplineId, id) {
                this.$router.push(`/modules/${relationshipId}/discipline/${disciplineId}/modules/${id}`);
            },

        },
        mounted() {
            this.getDisciplines();
        },
    }
</script>

<style lang="scss" scoped>
    .Layout {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 100vh;
        background: url("../assets/Disciplines-bg.jpg") center;
        background-size: cover;
    }

    .Disciplines {
        display: flex;
        flex-direction: column;
        justify-content: center;
        padding: 20px;
        background: rgba(74, 74, 74, 0.6);
        box-shadow: 0 0 8px 0 rgba(0, 0, 0, .7);
        border: 2px solid #4e4e4e;
        max-height: 80vh;

        &__you {
            width: 70%;
            color: #fff;
            text-shadow: -5px 1px 15px black;
            margin-bottom: 4px;
            background: rgba(74, 74, 74, 0.6);
            box-shadow: 0 0 8px 0 rgba(0, 0, 0, .7);
            border: 2px solid #4e4e4e;
            padding: 5px 10px;
            display: flex;
            justify-content: space-between;

            &-name {
                font-weight: 600;
                text-shadow: 0 0 20px black;
            }
        }

        &__title {
            font-size: 17px;
            font-weight: 500;
            color: #fff;
            text-shadow: -2px 5px 8px black;
            margin-top: 5px;
            margin-bottom: 2rem;
        }

        &__spinner {
            align-self: center;
        }

        &__discipline {
            min-height: 36px;
            width: 100%;
        }

        &__module {
            padding: 5px;
            color: #fff;
            display: block;
            text-shadow: 0 6px 12px black;
            transition: transform .3s;

            &:hover {
                transform: translateY(-1px);
                cursor: pointer;
                text-shadow: 0 9px 12px black;
            }
        }

        &__wrap {
            display: flex;
            flex-direction: column;
            overflow-y: auto;

            &::-webkit-scrollbar {
                width: 5px;
            }

            &::-webkit-scrollbar-track {
                -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
            }

            &::-webkit-scrollbar-thumb {
                background-color: darkgrey;
                outline: 1px solid slategrey;
            }
        }

        &__logout {
            cursor: pointer;
            text-shadow: 0 6px 12px black;
            transition: transform .3s;

            &:hover {
                transform: translateY(-1px);
                cursor: pointer;
                text-shadow: 0 9px 12px black;
            }
        }
    }

</style>
