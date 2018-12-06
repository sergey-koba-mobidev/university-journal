class StudentModule < ActiveRecord::Base
  class Generate < Trailblazer::Operation
    step :find_model
    step :get_discipline_module
    step :generate

    def find_model(options, params:, current_user:, **)
      options[:model] = Visit.where(id: params[:id]).first
      if options[:model].nil?
        options[:error_msg] = 'Visit not found'
        return false
      end
      true
    end

    def get_discipline_module(options, params:, current_user:, **)
      options[:discipline_module] = DisciplineModule.where(id: options[:model].object_id).first
      if options[:discipline_module].nil?
        options[:error_msg] = 'Module is not found. Cannot generate questions.'
        return false
      end
      true
    end

    def generate(options, params:, current_user:, **)
      questions, answers, results = [], [], []
      options[:discipline_module].question_groups.each do |group|
        group_questions = group.questions 
        if group_questions.count > 0
          offset = rand(group_questions.count)
          question = group_questions.offset(offset).first
          questions << {
            kind: question.kind,
            variants: question.variants,
            description: question.description
          }
          answers << nil
          results << nil
        end
      end
      options[:student_module] = StudentModule.create({
        visit_id: options[:model].id,
        user_id: current_user.id,
        status: StudentModule.statuses['started'],
        total: 0,
        opened_until: Time.now.utc + options[:discipline_module].duration,
        questions: questions,
        answers: answers,
        results: results
      })
      true
    end
  end
end