class Visit < ActiveRecord::Base
  belongs_to :relationship
  has_many :attends, dependent: :destroy

  enum kind: [:lab, :lecture, :module, :homework]

  default_scope { order(:created_at) }
end
