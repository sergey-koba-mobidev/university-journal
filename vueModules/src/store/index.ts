import Vue from "vue";
import Vuex from "vuex";

import auth, { AuthState } from "./auth";
import disciplines, { DisciplinesState } from "./disciplines";
import module, { ModuleState } from "./module";
import teacher, { TeacherState } from "./teacher";
import group, { GroupState } from "./group";

Vue.use(Vuex);

export interface RootState {
    auth: AuthState;
    disciplines: DisciplinesState;
    module: ModuleState;
    teacher: TeacherState;
    group: GroupState;
}

export default new Vuex.Store<any>({
    modules: {
        auth,
        disciplines,
        module,
        teacher,
        group
    },
});
