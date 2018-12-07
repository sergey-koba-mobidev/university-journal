class StudentModule < ActiveRecord::Base
  class Answer < Trailblazer::Operation
    step Model(Visit, :find_by)
    step Policy::Pundit( VisitPolicy, :show? )
    step :check_enabled
    step :get_module
    step :check_timeout
    step :answer
    
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

    def check_timeout(options, params:, **)
      if Time.now.utc > options[:student_module].opened_until
        options[:error_msg] = 'Time is out. Module has finished you cannot answer anymore.'
        return false
      end
      true
    end

    def answer(options, params:, **)
      options[:student_module].answers = options[:student_module].answers.map do |item| 
        if item["id"]==params[:question_id].to_i 
          item["answer"] = params[:answer]
        end
        item
      end
      options[:student_module].save
      true
    end
  end
end