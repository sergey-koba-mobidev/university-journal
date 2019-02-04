<template>
    <div>
        <div class="TeacherDisciplines">
            <div class="TeacherDisciplines__title">Модули для дисциплины</div>
            <div class="TeacherDisciplines__wrap" >
                <spinner class="TeacherDisciplines__spinner" v-if="loading"/>
                <BaseCollapse
                        v-for="(discipline, index) in disciplines"
                        :index="index + 1"
                        :key="index"
                        v-else
                >
                    <div slot="header">
                        <a class="waves-effect waves-light btn TeacherDisciplines__discipline"> {{ discipline.name }} </a>
                    </div>
                    <div slot="content">
                        <div v-for="module in discipline.modules" class="TeacherDisciplines__moduleWrap">
                            <a class="TeacherDisciplines__module" @click="handleShowForm(discipline.id, module.id)">
                                {{ module.title }}
                            </a>
                            <div class="TeacherDisciplines__buttons">
                                <i class="material-icons TeacherDisciplines__buttons-icon">close</i>
                            </div>
                        </div>
                        <a class="waves-effect waves-light btn TeacherDisciplines__module-create" @click="handleShowForm(discipline.id)">СОЗДАТЬ НОВЫЙ МОДУЛЬ </a>
                    </div>
                </BaseCollapse>
            </div>
        </div>
        <modal @close="" v-if="false">
            <div slot="header">Удаление</div>
            <div slot="body">
                <div>Вы уверены, что хотите удалить модуль?</div>
            </div>
        </modal>
    </div>
</template>

<script>
    import { mapState } from "vuex";
    import spinner from "../../public/spinner.svg";
    import BaseCollapse from "./BaseCollapse";
    import modal from "./BaseModalWindow";

    export default {
        name: "TeacherModules",
        components: {
            spinner,
            BaseCollapse,
            modal
        },
        computed: {
            ...mapState({
                disciplines: state => state.teacher.disciplines,
                loading: state => state.teacher.fetchStatus === "init" ||
                         state.teacher.fetchStatus === "loading",
            }),
        },
        methods: {
            handleShowForm(disciplineId, moduleId) {
                this.$router.push(`/modules/teacher/module/${disciplineId}/${moduleId}`);
            }
        },
    }
</script>

<style lang="scss" scoped>
    .TeacherDisciplines {
        display: flex;
        flex-direction: column;
        justify-content: center;
        padding: 20px;
        background: rgba(74, 74, 74, 0.6);
        box-shadow: 0 0 8px 0 rgba(0, 0, 0, .7);
        border: 2px solid #4e4e4e;
        max-height: 80vh;

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

            &-create {
                font-size: 11px;
                height: 30px;
                background: rgba(36, 166, 154, .31);
                min-height: 30px;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            &Wrap {
                position: relative;
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

        &__buttons {
            position: absolute;
            top: 0;
            right: 0;
            bottom: 0;
            display: flex;
            align-items: center;
            justify-content: space-around;
            width: 100px;

            &-icon {
                text-shadow: 0 9px 12px #23504b;
                transition: transform .3s, color .3s;
                color: #cecece;
                font-size: 21px;


                &:hover {
                    transform: translateY(-1px);
                    cursor: pointer;
                    text-shadow: 0 9px 12px #23504b;
                    color: #e9f3f2;
                }
            }
        }
    }
</style>
