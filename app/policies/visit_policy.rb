class VisitPolicy < ApplicationPolicy
  def show?
    user_group = user.groups.where(year: Time.zone.now.year).first
    user.admin? || user.teacher? || user_group.id = record.relationship.group_id
  end
end