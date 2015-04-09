class Discipline < ActiveRecord::Base
  belongs_to :user
  has_many :relationships, dependent: :destroy

  validates :title, presence: true

  default_scope { order 'title'}
end
