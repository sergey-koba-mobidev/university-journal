class Api::V1::UsersController < Api::ApiController
  skip_before_action :validate_auth_token, only: [:sign_in]

  def sign_in
    result = Session::SignIn.(params: params)
    
    if result.success?
      render_ok_json(Api::V1::User::Representer.new(result[:user]))
    else
      render_request_error_json(I18n.t "api.sign_in_failure")
    end
  end
end
