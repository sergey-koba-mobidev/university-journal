class Question < ActiveRecord::Base
  class Delete < Trailblazer::Operation
    step Model( Question, :find_by )
    step Policy::Pundit( QuestionPolicy, :delete? )
    step :delete

    def delete(options, params:, **)
      options[:model].destroy
    end
  end
end