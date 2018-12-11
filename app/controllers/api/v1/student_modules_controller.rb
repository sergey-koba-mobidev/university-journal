class Api::V1::StudentModulesController < Api::ApiController
  def show
    result = StudentModule::Get.(params: {id: params[:id]}, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::StudentModule::Representer.new(result[:student_module]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def answer
    result = StudentModule::Answer.(params: {id: params[:id], question_id: params[:question_id], answer: params[:answer]}, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::StudentModule::Representer.new(result[:student_module]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def finish
    result = StudentModule::Finish.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::StudentModule::Representer.new(result[:student_module]))
    else
      render_request_error_json(result[:error_msg])
    end
  end
end