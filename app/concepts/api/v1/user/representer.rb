require 'representable/json'
require 'jwt'

class Api::V1::User::Representer < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :email
  property :name
  property :role
  property :api_token, exec_context: :decorator

  def api_token
    payload = { :user_id => represented.id }
    JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
  end
end
