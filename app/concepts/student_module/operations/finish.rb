class StudentModule < ActiveRecord::Base
  class Finish < Trailblazer::Operation
    step Model(Visit, :find_by)
    step Policy::Pundit( VisitPolicy, :show? )
    step :check_enabled
    step :get_module
    step :finish
    
    def check_enabled(options, params:, **)
      if !options[:model].enabled
        options[:error_msg] = 'You cannot pass test right now. Ask teacher to enable this function.'
        return false
      end
      true
    end

    def get_module(options, params:, **)
      student_modules = StudentModule.where('visit_id = ? and user_id = ? and status != ?', options[:model].id, options[:current_user].id, StudentModule.statuses['deleted']).all
      if student_modules.size > 0
        options[:student_module] = student_modules.first
      else 
        options[:error_msg] = 'Cannot find module.'
        return false
      end
      true
    end

    def finish(options, params:, **)
      options[:student_module].update_attribute(:status, StudentModule.statuses['finished'])
      true
    end
  end
end