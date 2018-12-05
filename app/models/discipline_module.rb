class DisciplineModule < ActiveRecord::Base
  belongs_to :discipline
  has_many :question_groups
end