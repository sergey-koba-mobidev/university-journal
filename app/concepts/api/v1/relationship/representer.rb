require 'representable/json'

class Api::V1::Relationship::Representer < Representable::Decorator
  include Representable::JSON
  defaults render_nil: true

  property :id
  property :semester_id
  property :group_id

  property :discipline, decorator: Api::V1::Discipline::Representer
end