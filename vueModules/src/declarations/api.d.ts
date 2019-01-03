interface CommonResponse<TResponse = any, TNotification = string> {
    _token: string;
    response: TResponse | null;
    status: number;
    errors: Hash<string[]> | null;
}

interface SignInRequest {
    email: string;
    password: string;
}

interface SignInResponse {
    api_token: string;
    created_at: string;
    email: string;
    id: number;
    name: string;
    role: string;
    updated_at: string;
}