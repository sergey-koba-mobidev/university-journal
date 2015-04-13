class Group < ActiveRecord::Base
  after_initialize :set_default_status, :if => :new_record?
  before_destroy :check_relationships

  has_many :relationships, dependent: :destroy
  has_many :groupings, :dependent => :destroy
  has_many :users, :through => :groupings

  validates :year, presence: true, numericality: true
  validates :title, presence: true

  default_scope { order 'title'}

  enum status: [:learning, :graduated]

  def set_default_status
    self.status ||= :learning
  end

  def title_year
    title + ' (' + year.to_s + ')'
  end

  def check_relationships
    if relationships.size > 0
      errors.add(:base, 'Cannot delete group. The group studies disciplines: ' + relationships.map {|r| r.discipline.title + ' ('+ r.semester.name + ')'}.join(', ').to_s)
      false
    end
  end

  class << self
    def by_semester(semester)
      where(year: semester.year)
    end
  end
end
