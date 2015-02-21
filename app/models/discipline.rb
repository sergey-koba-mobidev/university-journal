class Discipline < ActiveRecord::Base
  belongs_to :user
  has_many :relationships, dependent: :destroy

  default_scope { order 'title'}
end
