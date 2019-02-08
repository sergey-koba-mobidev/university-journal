class DisciplineModule < ActiveRecord::Base
  class Show < Trailblazer::Operation
    step Model( DisciplineModule, :find_by )
    step Policy::Pundit( DisciplineModulePolicy, :show? )
    step :get_discipline

    def get_discipline(options, params:, **)
      options[:discipline] = Discipline.where(id: params[:discipline_id]).first
      if options[:discipline].nil?
        options[:error_msg] = 'Discipline not found'
        return false
      end
      true
    end
  end
end