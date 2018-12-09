class Api::V1::QuestionsController < Api::ApiController
  def index
    result = Question::List.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::Question::Representer.for_collection.new(result[:models]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def create
    result = Question::Create.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::Question::Representer.new(result[:model]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def update
    result = Question::Update.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::Question::Representer.new(result[:model]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def delete
    result = Question::Delete.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json()
    else
      render_request_error_json(result[:error_msg])
    end
  end
end