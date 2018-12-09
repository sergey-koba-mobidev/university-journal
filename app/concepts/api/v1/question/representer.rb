require 'representable/json'

class Api::V1::Question::Representer < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true
  
  property :id
  property :description
  property :question_group_id
  property :kind
  property :answer
  property :variants
  
  property :created_at
  property :updated_at
end
