class AttendsController < ApplicationController
  before_action :set_attend, only: [:update, :update_mark, :update_title]
  before_action AdminOrTeacherActionCallback

  respond_to :js

  def create
    @attend = Attend.new(attend_params)

    existing_attend = Attend.where(
        visit_id: @attend.visit_id,
        user_id: @attend.user_id,
        kind: Visit.kinds[@attend.visit.kind],
        relationship_id: @attend.visit.relationship_id,
        group_id: @attend.visit.relationship.group_id,
        discipline_id: @attend.visit.relationship.discipline_id,
        semester_id: @attend.visit.relationship.semester_id
    )
    respond_with existing_attend if existing_attend.present?

    @attend.kind = Visit.kinds[@attend.visit.kind]
    @attend.relationship_id = @attend.visit.relationship_id
    @attend.group_id = @attend.visit.relationship.group_id
    @attend.discipline_id = @attend.visit.relationship.discipline_id
    @attend.semester_id = @attend.visit.relationship.semester_id
    if owner_or_admin(@attend.visit.relationship.discipline) && @attend.save
      @attend.relationship.touch
      respond_with @attend
    else
      redirect_back fallback_location: root_path, alert: 'Access denied!'
    end
  end

  def update
    @attend.presence = params[:attend][:presence]
    if owner_or_admin(@attend.visit.relationship.discipline) && @attend.save
      @attend.relationship.touch
      respond_with @attend
    else
      redirect_back fallback_location: root_path, alert: 'Access denied!'
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

  def update_title
    @attend.title = params[:attend][:title]
    if owner_or_admin(@attend.visit.relationship.discipline) && @attend.save
      @attend.relationship.touch
      redirect_back fallback_location: root_path, notice: 'Title updated!'
    else
      redirect_back fallback_location: root_path, alert: 'Access denied!'
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
