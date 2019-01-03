<template>
    <div class="BaseValidationError" :class="{'is-active': !!error, 'is-small': small}">
        <span class="BaseValidationError__message">{{error}}</span>
    </div>
</template>

<script>
    export default {
        name: "BaseValidationError",
        props: {
            formKey: {
                type: String,
                required: true
            },
            field: {
                type: String,
                required: true
            },
            small: {
                type: Boolean
            }
        },
        computed: {
            error() {
                return this.$store.getters[`${this.formKey}/error`](this.field);
            }
        }
    };
</script>
<style lang="scss">
    .BaseValidationError {
        font-weight: 400;
        font-size: 14px;
        color: #dc0000;
        min-height: 21px;
        overflow: hidden;

        &__message {
            display: block;
            opacity: 0;
            transition: all 0.2s cubic-bezier(0.44, 0.13, 0.31, 1.23);
            transform: translateY(-100%);
        }

        &.is-active & {
            &__message {
                opacity: 1;
                transform: translateY(4px);
            }
        }
    }
</style>
