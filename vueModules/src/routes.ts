import auth from "./pages/Auth.vue";
import disciplines from "./pages/Disciplines.vue";
import module from "./pages/Module.vue";
import result from "./pages/Result.vue";
import teacher from "./pages/Teacher.vue";
import createModuleForm from "./pages/CreateModuleForm.vue";
import group from "./pages/Group.vue";

const routes = [
    {
        path: '/',
        component: auth,
        redirect: "/auth"
    },
    {
        path: '/auth',
        component: auth,
        beforeEnter: (to, from, next) => {
            const logined = localStorage.getItem('logined');
            const role = logined
                ? JSON.parse(localStorage.getItem('user')).role
                : "" ;

            next(logined
                ? role === 'student'
                    ? "/disciplines"
                    : "/teacher"
                : "/auth");
        }
    },
    {
        path: "/disciplines",
        component: disciplines,
        meta: { requiresAuth: true }
    },
    {
        path: `/disciplines/:disciplineId/modules/:id`,
        component: module,
        meta: { requiresAuth: true }
    },
    {
        path: `/result`,
        component: result,
        meta: { requiresAuth: true }
    },
    {
        name: "teacher",
        path: `/teacher`,
        component: teacher,
        meta: { requiresAuth: true }
    },
    {
        path: `/teacher/discipline/:disciplineId/create-module`,
        component: createModuleForm,
        meta: { requiresAuth: true }
    },
    {
        path: `/teacher/group/:groupId`,
        component: group,
        meta: { requiresAuth: true }
    }
];

export default routes;