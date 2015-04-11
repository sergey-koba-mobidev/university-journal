class Relationship < ActiveRecord::Base
  serialize :proportions
  scope :filter_discipline, ->(discipline) { where("discipline_id = ?", discipline.id) }

  belongs_to :semester
  belongs_to :discipline
  belongs_to :group
  has_many :visits, dependent: :destroy

  validates_uniqueness_of :group_id, scope: [:discipline_id, :semester_id], message: ' and discipline are already in semester'
end
