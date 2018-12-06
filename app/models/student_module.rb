class StudentModule < ActiveRecord::Base
  belongs_to :visit
  belongs_to :user

  enum status: [:started, :finished, :deleted]
end