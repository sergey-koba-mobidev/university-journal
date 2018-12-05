require 'representable/json'

class Api::V1::Visit::Representer < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :title
  property :relationship_id
  property :kind
  property :enabled
  property :object_id

  property :created_at
  property :updated_at
end