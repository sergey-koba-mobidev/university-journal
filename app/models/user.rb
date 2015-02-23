class User < ActiveRecord::Base
  has_many :disciplines, dependent: :destroy
  has_many :attends, dependent: :destroy

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

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      where(nil)
    end
  end
end
