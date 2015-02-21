class User < ActiveRecord::Base
  has_many :disciplines, dependent: :destroy

  enum role: [:student, :teacher, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :student
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def allowed_disciplines
    if admin?
      Discipline.all
    else
      disciplines
    end
  end
end
