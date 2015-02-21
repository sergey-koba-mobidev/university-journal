class Visit < ActiveRecord::Base
  belongs_to :relationship

  enum type: [:lab, :lecture, :module, :exam]
end
