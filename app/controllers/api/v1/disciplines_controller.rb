class Api::V1::DisciplinesController < Api::ApiController
  def index
    result = Discipline::List.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::Discipline::Representer.for_collection.new(result[:models]))
    else
      render_request_error_json(result[:error_msg])
    end
  end
end