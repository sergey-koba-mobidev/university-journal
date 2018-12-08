class DisciplineModule < ActiveRecord::Base
  class Create < Trailblazer::Operation
    step Model( DisciplineModule, :new )
    step Policy::Pundit( DisciplineModulePolicy, :create? )
    step Contract::Build( constant: DisciplineModule::Contracts::Create )
    step Contract::Validate()
    step :get_discipline
    step :save
    failure :prepare_error

    def get_discipline(options, params:, **)
      options[:discipline] = Discipline.where(id: params[:discipline_id]).first
      if options[:discipline].nil?
        options[:error_msg] = 'Discipline not found'
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