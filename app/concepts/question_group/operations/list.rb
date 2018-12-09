class QuestionGroup < ActiveRecord::Base
  class List < Trailblazer::Operation
    step Policy::Pundit( QuestionGroupPolicy, :list? )
    step :get_discipline_module
    step :get_groups

    def get_discipline_module(options, params:, **)
      options[:discipline_module] = DisciplineModule.where(id: params[:discipline_module_id]).first
      if options[:discipline_module].nil?
        options[:error_msg] = 'Discipline module not found'
        return false
      end
      true
    end

    def get_groups(options, params:, current_user:, **)
      options[:models] = options[:discipline_module].question_groups
    end
  end
end