class DisciplineModule < ActiveRecord::Base
  class Delete < Trailblazer::Operation
    step Model( DisciplineModule, :find_by )
    step Policy::Pundit( DisciplineModulePolicy, :delete? )
    step :delete

    def delete(options, params:, **)
      options[:model].destroy
    end
  end
end