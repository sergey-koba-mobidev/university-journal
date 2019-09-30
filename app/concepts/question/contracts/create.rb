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
      validates :answer, presence: true, unless: :is_open_question?
      validates :variants, presence: true, unless: :is_open_question?
      validates :question_group_id, presence: true

      def is_open_question?
        kind == 0
      end
    end
  end
end