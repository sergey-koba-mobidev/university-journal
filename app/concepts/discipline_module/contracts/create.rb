class DisciplineModule < ActiveRecord::Base
  class Contracts
    class Create < Reform::Form
      property :title
      property :discipline_id
      property :duration

      validates :title,  length: 2..33, presence: true
      validates :duration, numericality: true, presence: true
      validates :discipline_id, presence: true
    end
  end
end