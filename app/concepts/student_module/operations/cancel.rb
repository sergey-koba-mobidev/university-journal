class StudentModule < ActiveRecord::Base
  class Cancel < Trailblazer::Operation
    step Model(StudentModule, :find_by)
    step Policy::Pundit( StudentModulePolicy, :cancel? )
    step :cancel

    def cancel(options, params:, **)
      options[:model].update_attribute(:status, StudentModule.statuses['deleted'])
      true
    end
  end
end