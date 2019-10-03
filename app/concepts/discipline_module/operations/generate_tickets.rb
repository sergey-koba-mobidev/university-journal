class DisciplineModule < ActiveRecord::Base
  class GenerateTickets < Trailblazer::Operation
    step Policy::Pundit( DisciplineModulePolicy, :create? )
    step Contract::Build( constant: DisciplineModule::Contracts::GenerateTickets )
    step Contract::Validate()
    step :generate

    def generate(options, params:, **)
      options[:tickets] = []
      params[:tickets_count].to_i.times do |i|
        questions = []
        params[:discipline_module].question_groups.each do |group|
          group_questions = group.questions 
          if group_questions.count > 0
            offset = rand(group_questions.count)
            question = group_questions.offset(offset).first
            questions << {
              id: question.id,
              kind: question.kind,
              variants: question.variants,
              description: question.description
            }
          end
        end
        options[:tickets].push({questions: questions})
      end
    end
  end
end