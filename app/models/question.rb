class Question < ActiveRecord::Base
  belongs_to :question_group
  enum kind: [:text, :one, :many]
end