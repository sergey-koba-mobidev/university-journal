import Vue from 'vue'

import App from './App.vue'
import store from "./store/index";
import Router from "vue-router";
import routes from "./routes"
import VueResource from "vue-resource";
import VShowSlide from 'v-show-slide'

Vue.use(VueResource);
Vue.use(Router);
Vue.use(VShowSlide);

const router = new Router({
    routes,
    mode: 'history'
});

router.beforeEach((to, from, next) => {
    const logined = localStorage.getItem('logined');

    if (to.matched.some(record => record.meta.requiresAuth) && !logined) {
        return next({
            path: '/auth',
            query: { ...to.query, redirect: to.fullPath }
        });
    }

    next();
});



new Vue({
  el: '#app',
  store,
  router,
  render: h => h(App)
});

export default router;

