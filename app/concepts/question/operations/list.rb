class Question < ActiveRecord::Base
  class List < Trailblazer::Operation
    step Policy::Pundit( QuestionPolicy, :list? )
    step :get_question_group
    step :get_questions

    def get_question_group(options, params:, **)
      options[:question_group] = QuestionGroup.where(id: params[:question_group_id]).first
      if options[:question_group].nil?
        options[:error_msg] = 'Question group not found'
        return false
      end
      true
    end

    def get_questions(options, params:, current_user:, **)
      options[:models] = options[:question_group].questions
    end
  end
end