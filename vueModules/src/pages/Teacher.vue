<template>
    <div class="Layout">
        <div class="Teacher__you">
            <div>
                Вы зашли под именем
                <span  class="Teacher__you-name">Коба Сергей</span>
            </div>
            <div class="Teacher__logout" @click="logoutUser">Выйти</div>
        </div>
        <div class="Teacher__row">
            <modules class="Teacher__row-col"/>
            <groups class="Teacher__row-col"/>
        </div>
    </div>
</template>

<script>
    import { mapState, mapActions } from "vuex";
    import modules from "../components/TeacherModules";
    import groups from "../components/QuestionsGroup";

    export default {
        name: 'Teacher',
        components: {
            modules,
            groups
        },
        computed: {
            ...mapState({
                name: state => state.auth.name || JSON.parse(localStorage.getItem('user')).name,
            }),
        },
        methods: {
            ...mapActions(["getDisciplinesList", "logoutUser"]),
        },
        mounted() {
            this.getDisciplinesList();
        },
    }
</script>

<style lang="scss" scoped>
    .Layout {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        min-height: 100vh;
        background: url("../assets/AddModule-bg.jpg") center;
        background-size: cover;
    }

    .Teacher {
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

        &__row {
            display: flex;
            justify-content: space-between;
            width: 70%;

            &-col {
                width: 49%;
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
