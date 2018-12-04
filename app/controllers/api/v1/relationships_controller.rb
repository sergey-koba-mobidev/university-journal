class Api::V1::RelationshipsController < Api::ApiController
  def current
    result = Relationship::GetCurrent.(params: {}, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::Relationship::Representer.for_collection.new(result[:relationships]))
    else
      render_request_error_json(result[:error_msg])
    end
  end
end