class StudentModule < ActiveRecord::Base
  class CheckAnswers < Trailblazer::Operation
    step Model(StudentModule, :find_by)
    step Policy::Pundit( StudentModulePolicy, :check_answers? )
    step :check_answers

    def check_answers(options, params:, **)
      options[:model].results = options[:model].results.map do |item| 
        answer = options[:model].answers.find {|a| a["id"] == item["id"]}
        right_answer = options[:model].right_answers.find {|a| a["id"] == item["id"]}
        question = Question.find(item["id"])
        next item if question.kind == "text"
        item["result"] = question.question_group.points if answer["answer"]&.gsub(' ', '') == right_answer["answer"]&.gsub(' ', '')
        item
      end
      options[:model].save
      true
    end
  end
end