class Question < ActiveRecord::Base
  class Create < Trailblazer::Operation
    step Model( Question, :new )
    step Policy::Pundit( QuestionPolicy, :create? )
    step Contract::Build( constant: Question::Contracts::Create )
    step Contract::Validate()
    step :get_question_group
    step :save
    failure :prepare_error

    def get_question_group(options, params:, **)
      options[:question_group] = QuestionGroup.where(id: params[:question_group_id]).first
      if options[:question_group].nil?
        options[:error_msg] = 'Question group not found'
        return false
      end
      true
    end

    def save(options, params:, **)
      options["contract.default"].save
    end

    def prepare_error(options, params:, **)
      if options[:error_msg].nil? && options["result.contract.default"].errors.messages.size > 0
        options[:error_msg] = options["result.contract.default"].errors.messages.to_a.join(", ")
      end
    end
  end
end