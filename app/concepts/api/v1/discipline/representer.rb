require 'representable/json'

class Api::V1::Discipline::Representer < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :title
  property :user_id
end