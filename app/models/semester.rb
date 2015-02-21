class Semester < ActiveRecord::Base
  has_many :relationships, dependent: :destroy

  enum pos: [:spring, :autumn]
  default_scope { order 'semesters.year, semesters.pos DESC'}

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
end
