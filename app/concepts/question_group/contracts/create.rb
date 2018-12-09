class QuestionGroup < ActiveRecord::Base
  class Contracts
    class Create < Reform::Form
      property :title
      property :discipline_module_id
      property :position
      property :points

      validates :title,  length: 2..33, presence: true
      validates :position, numericality: true, presence: true
      validates :points, numericality: true, presence: true
      validates :discipline_module_id, presence: true
    end
  end
end