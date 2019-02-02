class StudentModule < ActiveRecord::Base
  class CopyResult < Trailblazer::Operation
    step Model(StudentModule, :find_by)
    step Policy::Pundit( StudentModulePolicy, :copy_result? )
    step :find_attend
    step :copy_result
    step :invalidate_cache

    def find_attend(options, params:, **)
      options[:attend] = Attend.where(visit_id: options[:model].visit_id, user_id: options[:model].user_id).first
      options[:attend] = create_attend(options[:model]) if options[:attend].nil?
      true
    end

    def copy_result(options, params:, **)
      options[:attend].mark = calculate_mark(options)
      options[:attend].save
      true
    end

    def invalidate_cache(options, params:, **)
      options[:attend].relationship.touch
      true
    end

    private

    def calculate_mark(options)
      student_module = options[:model]
      total = student_module.total
      attend = options[:attend]
      return total.to_i if attend.relationship.proportions.nil?
      per_module = attend.relationship.proportions["module_per_each"].to_i
      max_total  = student_module.questions.map{|q| Question.find(q["id"]).question_group.points || 0}.reduce(:+)
      (total * per_module / max_total).to_i
    end
    
    def create_attend(student_module)
      visit = student_module.visit
      Attend.create(
        visit_id: student_module.visit_id,
        user_id: student_module.user_id,
        kind: Visit.kinds[visit.kind],
        group_id: visit.relationship.group_id,
        discipline_id: visit.relationship.discipline_id,
        semester_id: visit.relationship.semester_id,
        relationship_id: visit.relationship_id
      ) 
    end
  end
end