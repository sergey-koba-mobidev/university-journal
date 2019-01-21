class QuestionGroup < ActiveRecord::Base
  class Show < Trailblazer::Operation
    step Model( QuestionGroup, :find_by )
    step Policy::Pundit( QuestionGroupPolicy, :show? )
  end
end