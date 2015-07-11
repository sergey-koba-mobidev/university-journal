class VisitorsController < ApplicationController
  def index
    if user_signed_in?
      @relationships = Relationship.where(discipline: current_user.disciplines.map {|d| d.id}).where(semester: Semester.current)
      if current_user.student?
        @homeworks = current_user.homeworks.joins(visit: [relationship: :discipline])
                         .where('relationships.semester_id = ?', Semester.current.id)
                         .where('homeworks.body != \'\'')
                         .order('homeworks.created_at desc')
      end
    end
  end
end
