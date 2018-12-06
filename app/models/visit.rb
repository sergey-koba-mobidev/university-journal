class Visit < ActiveRecord::Base
  belongs_to :relationship
  has_many :attends, dependent: :destroy
  has_many :student_modules

  enum kind: [:lab, :lecture, :module, :homework]

  default_scope { order(:created_at) }
end
