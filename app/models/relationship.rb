class Relationship < ActiveRecord::Base
  belongs_to :semester
  belongs_to :discipline
  belongs_to :group
  has_many :visits, dependent: :destroy
end
