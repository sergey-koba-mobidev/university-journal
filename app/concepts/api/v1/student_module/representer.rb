require 'representable/json'

class Api::V1::StudentModule::Representer < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :user_id
  property :visit_id
  property :status
  property :questions
  property :answers
  property :results
  property :total
  property :opened_until
  property :checked
  
  property :created_at
  property :updated_at
end
