class Api::V1::DisciplineModulesController < Api::ApiController
  def index
    result = DisciplineModule::List.(params: {discipline_id: params[:discipline_id]}, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::DisciplineModule::Representer.for_collection.new(result[:modules]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def show
    result = DisciplineModule::Show.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::DisciplineModule::Representer.new(result[:model]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def create
    result = DisciplineModule::Create.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::DisciplineModule::Representer.new(result[:model]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def update
    result = DisciplineModule::Update.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::DisciplineModule::Representer.new(result[:model]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def delete
    result = DisciplineModule::Delete.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json()
    else
      render_request_error_json(result[:error_msg])
    end
  end
end