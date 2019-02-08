class StudentModule < ActiveRecord::Base
  class FinishCheck < Trailblazer::Operation
    step Model(StudentModule, :find_by)
    step Policy::Pundit( StudentModulePolicy, :finish_check? )
    step :finish_check

    def finish_check(options, params:, **)
      options[:model].total = options[:model].results.map{|r| r["result"] || 0}.reduce(:+) 
      options[:model].checked = true
      options[:model].save
      true
    end
  end
end