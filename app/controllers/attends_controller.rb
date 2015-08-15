class AttendsController < ApplicationController
  before_action :set_attend, only: [:update, :update_mark]
  before_action AdminOrTeacherActionCallback

  respond_to :js

  def create
    @attend = Attend.new(attend_params)
    @attend.kind = Visit.kinds[@attend.visit.kind]
    @attend.relationship_id = @attend.visit.relationship_id
    @attend.group_id = @attend.visit.relationship.group_id
    @attend.discipline_id = @attend.visit.relationship.discipline_id
    @attend.semester_id = @attend.visit.relationship.semester_id
    if owner_or_admin(@attend.visit.relationship.discipline) && @attend.save
      @attend.relationship.touch
      respond_with @attend
    else
      redirect_to :back, alert: 'Access denied!'
    end
  end

  def update
    @attend.presence = params[:attend][:presence]
    if owner_or_admin(@attend.visit.relationship.discipline) && @attend.save
      @attend.relationship.touch
      respond_with @attend
    else
      redirect_to :back, alert: 'Access denied!'
    end
  end

  def update_mark
    @attend.mark = params[:attend][:mark]
    if owner_or_admin(@attend.visit.relationship.discipline) && @attend.save
      @attend.relationship.touch
      respond_with @attend
    else
      respond_with @attend, template: 'attends/_mark_error'
    end
  end

  private

  def set_attend
    @attend = Attend.find(params[:id])
  end

  def attend_params
    params.require(:attend).permit(:visit_id, :user_id, :presence, :mark, :mark_ects)
  end
end
