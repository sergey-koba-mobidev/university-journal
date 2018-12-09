class QuestionGroup < ActiveRecord::Base
  class Create < Trailblazer::Operation
    step Model( QuestionGroup, :new )
    step Policy::Pundit( QuestionGroupPolicy, :create? )
    step Contract::Build( constant: QuestionGroup::Contracts::Create )
    step Contract::Validate()
    step :get_discipline_module
    step :save
    failure :prepare_error

    def get_discipline_module(options, params:, **)
      options[:discipline_module] = DisciplineModule.where(id: params[:discipline_module_id]).first
      if options[:discipline_module].nil?
        options[:error_msg] = 'Discipline module not found'
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