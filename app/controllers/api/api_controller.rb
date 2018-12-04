class Api::ApiController < ApplicationController
  around_action :catch_halt
  around_action :catch_not_found

  skip_before_action :verify_authenticity_token
#  skip_before_action :require_login, :raise => false

  before_action :validate_json_request
  before_action :validate_auth_token

  private

  def catch_halt
    catch :halt do
      yield
    end
  end

  def catch_not_found
    begin
      yield
    rescue ActionController::RoutingError, ActiveRecord::RecordNotFound
      render_not_found_json
    end
  end

  def validate_auth_token
    token = bearer_token
    if token
      begin
        decoded_token = JWT.decode token, Rails.application.secrets.secret_key_base, true, { :algorithm => 'HS256' }
      rescue JWT::DecodeError => e
        decoded_token = []
      end

      payload = get_payload(decoded_token)
      if payload
        user = User.find(payload['user_id'])
        if user
          @user = user
          return true
        end
      end
    end

    render_error_json(['Auth token is not correct or user not found'], 401)
  end

  def current_user 
    @user
  end

  def bearer_token
    pattern = /^Bearer /
    header = request.headers["Authorization"]
    header.gsub(pattern, '') if header && header.match(pattern)
  end

  def get_payload(decoded_token)
    decoded_token[0]
  end

  def validate_json_request
    return if request.content_type == 'application/json'
    render_error_json(['Wrong Content-Type. Only application/json is accepted'], 406)
  end

  def render_ok_json(payload = nil, status = 0)
    render json: { status: status, response: payload }, status: 200 and throw :halt
  end

  def render_error_json(msg = 'Unknown error', status = 200)
    render json: { status: 1, error: msg}, status: status and throw :halt
  end

  def render_request_error_json(msg)
    render_error_json(msg, 400)
  end

  def render_not_found_json(msg = 'Not found')
    render_error_json([msg], 404)
  end
end
