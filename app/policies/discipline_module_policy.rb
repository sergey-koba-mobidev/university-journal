class DisciplineModulePolicy < ApplicationPolicy
  def list?
    user.admin? || user.teacher?
  end
end