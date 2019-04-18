<template>
    <transition class="Modal" name="Modal">
        <div class="Modal__mask">
            <div class="Modal__container">
                <i class="material-icons Modal__close" @click="$emit('close')">clear</i>
                <div class="Modal__title"><slot name="header"></slot></div>
                <div class="Modal__body"><slot name="body"></slot></div>
                <button class="btn waves-effect waves-light Result__btn" type="button" name="action" @click="handleCancel">Нет, отмена</button>
                <button class="btn waves-effect waves-light Result__btn" type="button" name="action" @click="handleOk">Да, завершить</button>
            </div>
        </div>
    </transition>
</template>

<script>
    export default {
        name: "Modal",
        props: {
            onOk: {
                type: Function,
                default: () => null,
            },
            onCancel: {
                type: Function,
                default: () => null,
            },
        },
        methods: {
            handleCloseOnEscape(e) {
                if (e.keyCode === 27) {
                    this.$emit("close");
                }
            },
            touchMoveHandler(e) {
                e.preventDefault();
            },
            stopBodyScrolling(bool) {
                if (bool === true) {
                    document.getElementById("app").addEventListener(
                        "touchmove",
                        this.touchMoveHandler,
                        false
                    );
                } else {
                    document.getElementById("app").removeEventListener(
                        "touchmove",
                        this.touchMoveHandler,
                        false
                    );
                }
            },
            handleCancel() {
                if (this.onCancel) {
                    this.$emit('handleCancel');
                }
                this.$emit('close');
            },
            handleOk() {
                if (this.onOk) {
                    this.$emit("handleOk");
                }
                this.$emit('close');
            }
        },
        mounted() {
            document.addEventListener("keydown", this.handleCloseOnEscape);
            document.body.classList.add("prevent-scroll");
            this.stopBodyScrolling(true);
        },
        destroyed() {
            document.removeEventListener("keydown", this.handleCloseOnEscape);
            document.body.classList.remove("prevent-scroll");
            this.stopBodyScrolling(false);
        }
    }
</script>

<style scoped lang="scss">
    .Modal {
        &-enter {
            opacity: 0;
        }

        &-leave-active {
            opacity: 0;
        }

        &-enter &__container,
        &-leave-active &__container {
            transform: scale(1.1);
        }

        &__mask {
            position: fixed;
            z-index: 999;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            transition: opacity 0.3s ease;
        }

        &__container {
            position: relative;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
            transition: all 0.3s ease;
            max-height: 100%;
            min-width: 30%;
            overflow: auto;
            background: #fff;
            text-align: center;
        }

        &__close {
            position: absolute;
            right: 20px;
            top: 20px;
            font-size: 1.5rem;
            cursor: pointer;
            transition: 0.3s color;

            &:hover,
            &:focus {
                color: #26a69a;
                transform: scale(1);
            }
        }

        &__title {
            font-size: 20px;
            font-weight: 500;
        }

        &__body {
            margin: 20px 0 35px;
        }
    }
</style>
