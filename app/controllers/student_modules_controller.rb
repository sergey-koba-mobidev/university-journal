class StudentModulesController < ApplicationController
  before_action :set_student_module, only: [:show, :destroy, :finish_check, :copy_result]
  before_action AdminOrTeacherActionCallback

  def show
  end

  def destroy
    result = StudentModule::Cancel.(params: params.permit(:id), current_user: current_user)
    
    if result.success?
      redirect_to result_visit_path(@student_module.visit), notice: t("student_module.cancel_success")
    else
      redirect_to result_visit_path(@student_module.visit), notice: t("student_module.cancel_error")
    end
  end

  def update_answer_result
    result = StudentModule::UpdateResult.(params: params.permit(:id, :answer_id, :result), current_user: current_user)
    
    if result.success?
      @answer_id = params.permit(:answer_id)[:answer_id]
      @result = result[:result]
    else
      @error = result[:error]
    end
  end

  def check_answers
    result = StudentModule::CheckAnswers.(params: params.permit(:id), current_user: current_user)
    
    if result.success?
      @student_module = result[:model]
    else
      @error = result[:error]
    end
  end

  def copy_result
    result = StudentModule::CopyResult.(params: params.permit(:id), current_user: current_user)
    
    if result.success?
      redirect_to result_visit_path(@student_module.visit), notice: t("student_module.result_copied")
    else
      redirect_to result_visit_path(@student_module.visit), notice: result[:error]
    end
  end

  def finish_check
    result = StudentModule::FinishCheck.(params: params.permit(:id), current_user: current_user)
    
    if result.success?
      redirect_to result_visit_path(@student_module.visit), notice: t("student_module.check_finished")
    else
      redirect_to result_visit_path(@student_module.visit), notice: result[:error]
    end
  end

  private

  def set_student_module
    @student_module = StudentModule.find(params[:id])
  end
end
