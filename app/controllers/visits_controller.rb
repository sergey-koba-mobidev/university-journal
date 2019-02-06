class VisitsController < ApplicationController
  before_action :set_visit, only: [:destroy, :update, :update_created_at, :result]
  before_action AdminOrTeacherActionCallback

  respond_to :js

  def create
    @visit = Visit.new(visit_params)
    if owner_or_admin(@visit.relationship.discipline) && @visit.save
      @visit.relationship.touch
      redirect_to relationship_path(@visit.relationship, kind: @visit.kind), notice: 'Successfully added!'
    else
      redirect_to relationship_path(@visit.relationship, kind: @visit.kind), alert: 'Access denied!'
    end
  end

  def update
    @visit.assign_attributes(visit_params)
    if owner_or_admin(@visit.relationship.discipline) && @visit.save
      @visit.relationship.touch
      respond_with @visit
    else
      redirect_back fallback_location: root_path, alert: 'Access denied!'
    end
  end

  def update_created_at
    day, month = params[:visit][:created_at].split('.')
    @visit.created_at = @visit.created_at.change(day: day, month: month)

    if owner_or_admin(@visit.relationship.discipline) && @visit.save
      @visit.relationship.touch
      respond_with @visit
    else
      redirect_back fallback_location: root_path, alert: 'Access denied!'
    end
  end

  def destroy
    if owner_or_admin(@visit.relationship.discipline)
      kind = @visit.kind
      relationship = @visit.relationship
      @visit.relationship.touch
      @visit.destroy
      redirect_to relationship_path(relationship, kind: kind), notice: 'Deleted!'
    else
      redirect_to relationship_path(relationship, kind: kind), alert: 'Access denied!'
    end
  end

  private

  def set_visit
    @visit = Visit.find(params[:id])
  end

  def visit_params
    params.require(:visit).permit(:relationship_id, :title, :kind, :enabled, :object_id)
  end

  def owner_or_admin(discipline)
    current_user.admin? || current_user.id == discipline.user_id
  end
end
