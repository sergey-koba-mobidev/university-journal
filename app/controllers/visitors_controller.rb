class VisitorsController < ApplicationController
  def index
    if user_signed_in? && Semester.current.present?
      @relationships = Relationship.where(discipline: current_user.disciplines.map {|d| d.id}).where(semester: Semester.current)
      if current_user.student?
        @homeworks = current_user.homeworks.joins(visit: [relationship: :discipline])
                          .where('relationships.semester_id = ?', Semester.current.id)
                          .where('homeworks.body != \'\'')
                          .order('homeworks.created_at desc')
      else
        @homeworks = Homework.joins(visit: [relationship: :discipline])
                          .where('relationships.semester_id = ?', Semester.current.id)
                          .where('homeworks.body is NULL')
                          .where('disciplines.id IN (?)', current_user.disciplines.select('id'))
                          .order('homeworks.created_at desc')
      end
    else
      @relationships = []
      @homeworks = []
    end
  end
end
