require 'representable/json'

class Api::V1::QuestionGroup::Representer < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true
  
  property :id
  property :title
  property :discipline_module_id
  property :position
  property :points
  
  property :created_at
  property :updated_at
end
