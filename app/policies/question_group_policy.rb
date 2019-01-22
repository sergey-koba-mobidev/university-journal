class QuestionGroupPolicy < ApplicationPolicy
  def list?
    user.admin? || user.teacher?
  end

  def show?
    list?
  end

  def create?
    list?
  end

  def update?
    list?
  end

  def delete?
    list?
  end
end