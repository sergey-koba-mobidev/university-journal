class QuestionGroup < ActiveRecord::Base
  class Update < Create
    step Model( QuestionGroup, :find_by ), override: true
    step Policy::Pundit( QuestionGroupPolicy, :update? ), override: true
  end
end