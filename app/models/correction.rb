class Correction < ActiveRecord::Base
  belongs_to :user
  belongs_to :homework
end
