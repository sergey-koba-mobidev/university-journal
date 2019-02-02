class StudentModule < ActiveRecord::Base
  class UpdateResult < Trailblazer::Operation
    step Model(StudentModule, :find_by)
    step Policy::Pundit( StudentModulePolicy, :update_result? )
    step :check_result_value
    step :update_result

    def check_result_value(options, params:, **)
      params[:result] = params[:result].to_i
      max_points = Question.find(params[:answer_id]).question_group.points
      params[:result] = max_points if params[:result] > max_points
      params[:result] = 0 if params[:result] < 0
      true
    end

    def update_result(options, params:, **)
      options[:model].results = options[:model].results.map do |item| 
        if item["id"]==params[:answer_id].to_i 
          item["result"] = params[:result]
        end
        item
      end
      options[:model].save
      options[:result] = params[:result]
      true
    end
  end
end