module DisciplineModulesHelper
  def for_select(discipline_modules)
    discipline_modules.collect { |dm| [dm.title, dm.id] }
  end
end