class Discipline < ActiveRecord::Base
  class List < Trailblazer::Operation
    step Policy::Pundit( DisciplinePolicy, :list? )
    step :get_disciplines

    def get_disciplines(options, params:, current_user:, **)
      options[:models] = Discipline.all
    end
  end
end