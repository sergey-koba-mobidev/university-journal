require 'representable/json'

class Api::V1::DisciplineModule::Representer < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :title
  property :discipline_id
  property :duration
  
  property :created_at
  property :updated_at
end
