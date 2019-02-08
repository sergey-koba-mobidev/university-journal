class StudentModulePolicy < ApplicationPolicy
  def cancel?
    user.admin? || user.teacher?
  end

  def update_result?
    cancel?
  end

  def check_answers?
    cancel?
  end

  def finish_check?
    cancel?
  end

  def copy_result?
    cancel?
  end
end