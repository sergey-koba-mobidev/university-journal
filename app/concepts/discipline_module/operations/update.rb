class DisciplineModule < ActiveRecord::Base
  class Update < Create
    step Model( DisciplineModule, :find_by ), override: true
    step Policy::Pundit( DisciplineModulePolicy, :update? ), override: true
  end
end