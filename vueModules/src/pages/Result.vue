<template>
    <div class="Layout">
        <div class="Result">
            <div class="Result__title">Модуль завершен!</div>
            <div class="Result__trueAnswers">Правильных ответов: <span class="Result__my">{{ trueAnswers }}</span> / {{totalQuestions}}</div>
            <div class="Result__points">Набрано баллов: <span class="Result__my">{{ points }}</span> / {{totalPoints}}</div>
            <button class="btn waves-effect waves-light Result__btn" type="submit" name="action">Ok, выйти из профиля</button>
        </div>
    </div>
</template>

<script>
    export default {
        name: "Results",
        data() {
            return {
                points: "18",
                totalPoints: "25",
                trueAnswers: 3,
                totalQuestions: 4
            }
        }
    }
</script>


<style lang="scss" scoped>
    .Layout {
        height: 100vh;
        background: url("../assets/Result-bg.jpg") center;
        background-size: cover;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .Result {
        background: rgba(255, 255, 255, 0.9);
        box-shadow: 0 0 18px #4c4c4c;
        min-width: 500px;
        padding-top: 1rem;
        padding-bottom: 2rem;
        text-align: center;

        &__title {
            font-weight: 600;
            font-size: 25px;
            margin-bottom: 3rem;
        }

        &__my {
            font-weight: 600;
            color: #00a293;
        }

        &__trueAnswers {
            margin-bottom: 1rem;
            font-size: 17px;
        }

        &__point {
            font-size: 17px;
        }

        &__btn {
            margin-top: 3rem;
        }
    }
</style>