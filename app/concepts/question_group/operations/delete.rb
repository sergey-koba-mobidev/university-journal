class QuestionGroup < ActiveRecord::Base
  class Delete < Trailblazer::Operation
    step Model( QuestionGroup, :find_by )
    step Policy::Pundit( QuestionGroupPolicy, :delete? )
    step :delete

    def delete(options, params:, **)
      options[:model].destroy
    end
  end
end