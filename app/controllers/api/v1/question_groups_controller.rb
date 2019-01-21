class Api::V1::QuestionGroupsController < Api::ApiController
  def show
    result = QuestionGroup::Show.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::QuestionGroup::Representer.new(result[:model]))
    else
      render_request_error_json(result[:error_msg])
    end
  end
  
  def index
    result = QuestionGroup::List.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::QuestionGroup::Representer.for_collection.new(result[:models]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def create
    result = QuestionGroup::Create.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::QuestionGroup::Representer.new(result[:model]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def update
    result = QuestionGroup::Update.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json(Api::V1::QuestionGroup::Representer.new(result[:model]))
    else
      render_request_error_json(result[:error_msg])
    end
  end

  def delete
    result = QuestionGroup::Delete.(params: params, current_user: current_user)
    
    if result.success?
      render_ok_json()
    else
      render_request_error_json(result[:error_msg])
    end
  end
end