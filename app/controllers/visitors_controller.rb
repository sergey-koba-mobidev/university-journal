class VisitorsController < ApplicationController
  def index
    if user_signed_in?
      @relationships = Relationship.where(discipline: current_user.disciplines.map {|d| d.id}).where(semester: Semester.current)
    end
  end
end
