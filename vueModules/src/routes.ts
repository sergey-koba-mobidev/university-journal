import auth from "./pages/Auth.vue";
import disciplines from "./pages/Disciplines.vue";
import module from "./pages/Module.vue";
import result from "./pages/Result.vue";
import teacher from "./pages/Teacher.vue";
import teacherModuleForm from "./pages/TeacherModuleForm.vue";
import group from "./pages/Group.vue";

const routes = [
    {
        path: '/modules',
        component: auth,
        redirect: "/modules/auth"
    },
    {
        path: '/modules/auth',
        component: auth,
        beforeEnter: (to, from, next) => {
            const logined = localStorage.getItem('logined');
            const role = logined
                ? JSON.parse(localStorage.getItem('user')).role
                : "" ;
            logined
            ? next(role === 'student'
                    ? "/modules/disciplines"
                    : "/modules/teacher"
            )
            : next();
        }
    },
    {
        path: "/modules/disciplines",
        component: disciplines,
        meta: { requiresAuth: true }
    },
    {
        path: `/modules/:relationshipId/discipline/:disciplineId/modules/:id`,
        component: module,
        meta: { requiresAuth: true }
    },
    {
        path: `/modules/result`,
        component: result,
        meta: { requiresAuth: true }
    },
    {
        name: "teacher",
        path: `/modules/teacher`,
        component: teacher,
        meta: { requiresAuth: true }
    },
    {
        path: `/modules/teacher/module/:disciplineId/:moduleId`,
        component: teacherModuleForm,
        meta: { requiresAuth: true }
    },
    {
        path: `/modules/teacher/group/:disciplineModuleId/:groupId`,
        component: group,
        meta: { requiresAuth: true }
    }
];

export default routes;
