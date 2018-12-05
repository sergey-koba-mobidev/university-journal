require 'representable/json'
require 'jwt'

class Api::V1::User::Representer < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :email
  property :name
  property :role
  property :api_token

  property :created_at
  property :updated_at
end
