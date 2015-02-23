class VisitsController < ApplicationController
  before_action :set_visit, only: [:destroy, :update]
  before_action AdminOrTeacherActionCallback

  respond_to :js

  def create
    @visit = Visit.new(visit_params)
    if owner_or_admin(@visit.relationship.discipline) && @visit.save
      redirect_to :back, notice: 'Successfully added!'
    else
      redirect_to :back, alert: 'Access denied!'
    end
  end

  def update
    @visit.title = params[:visit][:title]
    if owner_or_admin(@visit.relationship.discipline) && @visit.save
      respond_with @visit
    else
      redirect_to :back, alert: 'Access denied!'
    end
  end

  def destroy
    if owner_or_admin(@visit.relationship.discipline)
      @visit.destroy
      redirect_to :back, notice: 'Deleted!'
    else
      redirect_to :back, alert: 'Access denied!'
    end
  end

  private

  def set_visit
    @visit = Visit.find(params[:id])
  end

  def visit_params
    params.require(:visit).permit(:relationship_id, :title, :kind)
  end

  def owner_or_admin(discipline)
    current_user.admin? || current_user.id == discipline.user_id
  end
end
