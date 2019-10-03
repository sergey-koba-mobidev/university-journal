class DisciplineModule < ActiveRecord::Base
  class Contracts
    class GenerateTickets < Reform::Form
      property :tickets_count, virtual: true
      property :discipline_module, virtual: true

      validates :tickets_count, numericality: true, presence: true
      validates :discipline_module, presence: true
    end
  end
end