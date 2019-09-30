<template>
    <div>
        <div class="Block">
            <div class="Block__title">Группы вопросов для модуля</div>
            <div class="Block__wrap" >
                <spinner class="Block__spinner" v-if="loading"/>
                <BaseCollapse
                    v-for="(module, index) in modules"
                    :index="index + 1"
                    :key="index"
                    @click="handleModuleClick($event,module.id)"
                    v-else
                >
                    <div slot="header">
                        <a class="waves-effect waves-light btn Block__discipline">
                            {{ module.title }}
                            <span class="Block__discipline-span"> ({{ module.discipline }}) </span>
                        </a>
                    </div>
                    <div slot="content">
                        <spinner class="Block__spinner" v-if="loadingGroups"/>
                        <div v-else v-for="(group, groupId) in groups" class="Block__moduleWrap">
                            <a class="Block__module" @click="handleShowGroup(group.disciplineModuleId, groupId)">
                                {{ group.title }} ({{ group.points }} балла)
                            </a>
                            <div class="Block__buttons">
                                <i class="material-icons Block__buttons-icon">close</i>
                            </div>
                        </div>
                        <a class="waves-effect waves-light btn Block__module-create" @click="">СОЗДАТЬ НОВУЮ ГРУППУ ВОПРОСОВ </a>
                    </div>
                </BaseCollapse>
            </div>
        </div>
        <modal @close="" v-if="false">
            <div slot="header">Удаление</div>
            <div slot="body">
                <div>Вы уверены, что хотите удалить группу вопросов?</div>
            </div>
        </modal>
    </div>
</template>

<script>
    import { mapState, mapActions } from "vuex";
    import spinner from "../../public/spinner.svg";
    import BaseCollapse from "./BaseCollapse";
    import modal from "./BaseModalWindow";

    export default {
        name: "TeacherGroups",
        components: {
            spinner,
            BaseCollapse,
            modal
        },
        computed: {
            ...mapState({
                disciplines: state => state.teacher.disciplines,
                groups: state => state.group.groups,
                loading: state => state.teacher.fetchStatus === "init" ||
                    state.teacher.fetchStatus === "loading",
                loadingGroups: state => state.group.fetchGroupsStatus === "init" ||
                    state.group.fetchGroupsStatus === "loading",

            }),
            modules() {
                const modules = [];

                for (let discipline of this.disciplines) {
                    const disciplineName = discipline.name;

                    for (let module of discipline.modules) {
                        modules.push({
                            title: module.title,
                            id: module.id,
                            discipline: disciplineName
                        });
                    }
                }

                return modules;
            }
        },
        methods: {
            ...mapActions(["getGroupsList"]),
            handleShowGroup(disciplineModuleId, groupId) {
                this.$router.push(`/modules/teacher/group/${disciplineModuleId}/${groupId}`);
            },
            handleModuleClick(isOpened, moduleId) {
                if (!isOpened) {
                    return;
                }
                this.getGroupsList(moduleId);
            }
        },
    }
</script>

<style lang="scss" scoped>
    .Block {
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
            padding-left: 1rem;
            padding-right: 1rem;
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

            &-span {
                text-transform: lowercase;
                color: #e4e4e4;
            }
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
            width: 50px;

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
