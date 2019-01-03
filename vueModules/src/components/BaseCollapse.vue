<template>
    <div class="BaseCollapse">
        <div class="BaseCollapse__header" @click="toggleContent">
            <slot name="header"></slot>
        </div>
        <div class="BaseCollapse__content" v-show-slide="contentOpen">
            <slot name="content"></slot>
        </div>
    </div>
</template>

<script>
    export default {
        name: "BaseCollapse",
        props: {
            index: {
                type: Number,
                default: 1
            },
        },
        data() {
            return {
                contentOpen: false
            };
        },
        methods: {
            toggleContent() {
                this.contentOpen = !this.contentOpen;

                this.$emit("click", this.contentOpen);
            },
        }
    }
</script>

<style lang="scss" scoped>
    .BaseCollapse {
        margin-bottom: 1rem;

        &__content {
            color: #fff;
            text-align: center;
            background: rgba(36, 166, 154, .45);
        }
    }
</style>