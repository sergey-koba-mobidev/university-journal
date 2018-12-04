class Api::V1::VisitsController < Api::ApiController
  def get_modules
    result = Visit::List.(params: {relationship_id: params[:relationship_id], kind: Visit.kinds[:module]}, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::Visit::Representer.for_collection.new(result[:visits]))
    else
      render_request_error_json(result[:error_msg])
    end
  end
end