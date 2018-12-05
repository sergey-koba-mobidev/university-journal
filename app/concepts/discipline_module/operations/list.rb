class DisciplineModule < ActiveRecord::Base
  class List < Trailblazer::Operation
    step Policy::Pundit( DisciplineModulePolicy, :list? )
    step :get_discipline
    step :get_modules

    def get_discipline(options, params:, current_user:, **)
      options[:discipline] = Discipline.where(id: params[:discipline_id]).first
      if options[:discipline].nil?
        options[:error_msg] = 'Discipline not found'
        return false
      end
      true
    end

    def get_modules(options, params:, current_user:, **)
      options[:modules] = options[:discipline].discipline_modules
    end
  end
end