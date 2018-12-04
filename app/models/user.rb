class User < ActiveRecord::Base
  after_initialize :set_default_role, :if => :new_record?
  before_destroy :check_groups

  has_many :disciplines, dependent: :destroy
  has_many :attends, dependent: :destroy
  has_many :groupings, :dependent => :destroy
  has_many :groups, :through => :groupings
  has_many :homeworks, dependent: :destroy

  default_scope { order("name ASC") }

  enum role: [:student, :teacher, :admin]

  def set_default_role
    self.role ||= :student
  end

  def api_token
    payload = { :user_id => id }
    JWT.encode payload, Rails.application.secrets.secret_key_base, 'HS256'
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
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

  def check_groups
    if groups.size > 0
      errors.add(:base, 'Cannot delete student. The student is a member of groups: ' + groups.map {|g| g.title_year}.join(', ').to_s)
      false
    end
  end
end
