import Vue from "vue";
const V = Vue as any;
import Http from "vue-resource";
import { stringify } from "querystring";

type HttpOptions = Http.HttpOptions;
type HttpResponse = Http.HttpResponse;

let host = 'http://localhost:3000/api';

type Response<T = {}> = Promise<CommonResponse<T>>;

interface GeneralMutateRequest<TBody = void, TParams = {}> {
    params?: TParams;
    body: TBody;
}

class ApiService {

    public postSignIn({ body }: GeneralMutateRequest<SignInRequest>):Response<SignInResponse> {
        return this.post(`/v1/sign_in`, body);
    }

    // STUDENTS
    public getRelationships() {
        return this.get(`/v1/relationships/current`);
    }

    public getModules(id: number) {
        return this.get(`/v1/relationships/${id}/modules`);
    }

    public getModule(relationshipId: number, moduleId: number) {
        return this.get(`/v1/relationships/${relationshipId}/modules/${moduleId}`);
    }

    public postAnswer({ params, body }) {
        return this.post(
            `/v1/relationships/${params.relationshipId}/modules/${params.moduleId}/questions/${params.questionId}/answer`,
            body
        );
    }


    // TEACHERS AND ADMINS
    public getDisciplines() {
        return this.get(`/v1/disciplines`);
    }

    public getCreatedModules(id: number) {
        return this.get(`/v1/disciplines/${id}/modules`);
    }

    public postCreateModule({ params, body }) {
        return this.post(
            `/v1/disciplines/${params.disciplineId}/modules`,
            body
        );
    }

    // question group
    public getQuestionGroups(id) {
        return this.get(`/v1/modules/${id}/question_groups`);
    }

    public getGroupQuestions(groupId) {
        return this.get(`/v1/question_groups/${groupId}/questions`);
    }

    public postUpdateGroup({ params, body }) {
        return this.post(
            `/v1/modules/${params.disciplineModuleId}/question_groups/${params.id}`,
            body
        );
    }

    public postUpdateQuestion({ params, body }) {
        return this.post(
            `/v1/question_groups/${params.questionGroupId}/questions/${params.id}`,
            body
        );
    }

    public postCreateQuestion({ params, body }) {
        return this.post(
            `/v1/question_groups/${params.questionGroupId}/questions`,
            body
        );
    }

    public deleteQuestion({ params }) {
        return this.delete(
            `/v1/question_groups/${params.questionGroupId}/questions/${params.id}`
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

declare global {
    interface Window {
        TOCKEN: string;
    }
}
