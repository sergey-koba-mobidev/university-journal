class Question < ActiveRecord::Base
  class Contracts
    class Create < Reform::Form
      property :description
      property :question_group_id
      property :kind
      property :answer
      property :variants

      validates :description, presence: true
      validates :kind, numericality: true, presence: true
      validates :answer, presence: true
      validates :variants, presence: true
      validates :question_group_id, presence: true
    end
  end
end