import Vue from "vue";
const V = Vue as any;
import Http from "vue-resource";
import { stringify } from "querystring";

type HttpOptions = Http.HttpOptions;
type HttpResponse = Http.HttpResponse;

let host = '/api/v1/';

type Response<T = {}> = Promise<CommonResponse<T>>;

interface GeneralMutateRequest<TBody = void, TParams = {}> {
    params?: TParams;
    body: TBody;
}

class ApiService {

    public postSignIn({ body }: GeneralMutateRequest<SignInRequest>):Response<SignInResponse> {
        return this.post(`sign_in`, body);
    }

    // STUDENTS
    public getRelationships() {
        return this.get(`relationships/current`);
    } // disciplines for student

    public getModules(id: number) {
        return this.get(`relationships/${id}/modules`);
    } // modules for discipline

    public getModule(relationshipId: number, moduleId: number) {
        return this.get(`relationships/${relationshipId}/modules/${moduleId}`);
    } // module questions

    public postAnswer({ params, body }) {
        return this.post(
            `relationships/${params.relationshipId}/modules/${params.moduleId}/questions/${params.questionId}/answer`,
            body
        );
    }

    public postFinishModule({ params }) {
        return this.post(
            `relationships/${params.relationshipId}/modules/${params.moduleId}/finish`,
            {}
        );
    }


    // TEACHERS AND ADMINS
    public getDisciplines() {
        return this.get(`disciplines`);
    }

    // modules
    public getModuleInfo(disciplineId: number, moduleId: number) {
        return this.get(`disciplines/${disciplineId}/modules/${moduleId}`);
    }

    public getCreatedModules(id: number) {
        return this.get(`disciplines/${id}/modules`);
    } // get all modules for teacher

    public postCreatedModule({ params, body }) {
        return this.post(
            `disciplines/${params.disciplineId}/modules`,
            body
        );
    }

    public postUpdatedModule({ params, body }) {
        return this.post(
            `disciplines/${params.disciplineId}/modules/${params.moduleId}`,
            body
        );
    }

    public deleteModule({ params }) {
        return this.delete(
            `disciplines/${params.disciplineId}/modules/${params.moduleId}`
        );
    }

    // question group
    public getQuestionGroups(id) {
        return this.get(`modules/${id}/question_groups`);
    } // get all groups for module

    public getGroupData(disciplineModuleId, id) {
        return this.get(`modules/${disciplineModuleId}/question_groups/${id}`);
    }

    public postUpdateGroup({ params, body }) {
        return this.post(
            `modules/${params.disciplineModuleId}/question_groups/${params.id}`,
            body
        );
    }

    // questions
    public getGroupQuestions(groupId) {
        return this.get(`question_groups/${groupId}/questions`);
    }

    public postCreateQuestion({ params, body }) {
        return this.post(
            `question_groups/${params.groupId}/questions`,
            body
        );
    }

    public postUpdateQuestion({ params, body }) {
        return this.post(
            `question_groups/${params.groupId}/questions/${params.id}`,
            body
        );
    }

    public deleteQuestion({ params }) {
        return this.delete(
            `question_groups/${params.groupId}/questions/${params.id}`
        );
    }


    private get(url: string, request?: HttpOptions) {
        const token = localStorage.getItem("token");

        V.http.headers.common.Authorization = `Bearer ${token}`;
        V.http.headers.common["Content-Type"] = "application/json";

        return V.http
            .get(`${host}${url}`, request)
            .then((response: HttpResponse) => response.json())
            .catch((error: HttpResponse) => Promise.resolve({response: null, errors: error, status: 422}));
    }

    private post(
        url: string,
        body: any,
        parseJson = true,
        request?: HttpOptions
    ) {
        return V.http
            .post(`${host}${url}`, body, request)
            .then(
                (response: HttpResponse) =>
                    parseJson ? response.json() : response.text()
            )
            .catch((error: HttpResponse) => Promise.resolve({response: null, errors: error, status: 422}));
    }

    private delete(url: string, request?: HttpOptions) {
        return V.http
            .delete(`${host}${url}`, request)
            .then((response: HttpResponse) => response.json())
            .catch((error: HttpResponse) => Promise.resolve({response: null, errors: error, status: 422}));
    }
}

export default new ApiService();