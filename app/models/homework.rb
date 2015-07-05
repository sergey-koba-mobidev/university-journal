class Homework < ActiveRecord::Base
  belongs_to :visit
  belongs_to :user
  has_one :correction

  validates :document, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :document
  validates_with AttachmentSizeValidator, :attributes => :document, :less_than => 10.megabytes

  has_attached_file :document
  validates_attachment :document, :content_type => {:content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)}
end
