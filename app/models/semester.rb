class Semester < ActiveRecord::Base
  has_many :relationships, dependent: :destroy

  enum pos: [:spring, :autumn]
  default_scope { order 'semesters.year, semesters.pos DESC' }

  validates :year, presence: true
  validates :pos, presence: true

  def name
    pos.to_s.capitalize+' '+year.to_s
  end

  def allowed_relationships(user)
    if user.admin?
      relationships
    else
      relationships.joins(:discipline).where('disciplines.user_id = ?', user.id)
    end
  end

  class << self
    def current
      begin
        Semester.find_by!(year: Time.zone.now.year, pos: (Time.zone.now.month<9) ? Semester.pos['spring'] : Semester.pos['autumn'])
      rescue
        nil
      end
    end
  end
end
