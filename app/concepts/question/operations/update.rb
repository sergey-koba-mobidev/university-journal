class Question < ActiveRecord::Base
  class Update < Create
    step Model( Question, :find_by ), override: true
    step Policy::Pundit( QuestionPolicy, :update? ), override: true
  end
end