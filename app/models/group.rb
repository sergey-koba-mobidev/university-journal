class Group < ActiveRecord::Base
  has_many :relationships, dependent: :destroy
  has_many :users, dependent: :nullify
  default_scope { order 'title'}

  validates :year, presence: true, numericality: true
  validates :title, presence: true

  enum status: [:learning, :graduated]
  after_initialize :set_default_status, :if => :new_record?

  def set_default_status
    self.status ||= :learning
  end
end
