class Api::V1::DisciplineModulesController < Api::ApiController
  def index
    result = DisciplineModule::List.(params: {discipline_id: params[:discipline_id]}, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::DisciplineModule::Representer.for_collection.new(result[:modules]))
    else
      render_request_error_json(result[:error_msg])
    end
  end
end