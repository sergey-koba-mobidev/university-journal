class Grouping < ActiveRecord::Base
  after_destroy :remove_attends

  belongs_to :user
  belongs_to :group

  validates_uniqueness_of :user_id, scope: :group_id, message: ' already in group'

  def remove_attends
    Attend.where(user_id: user_id, group_id: group_id).destroy_all
  end
end
