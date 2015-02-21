class VisitsController < ApplicationController
  def create
    @visit = Visit.new(visit_params)
    if owner_or_admin(@visit.relationship.discipline) && @visit.save
      redirect_to :back, notice: 'Successfully added!'
    else
      redirect_to :back, alert: 'Access denied!'
    end
  end

  def destroy

  end

  private

  def set_visit
    @visit = Visit.find(params[:id])
  end

  def visit_params
    params.require(:visit).permit(:relationship_id, :title, :type)
  end

  def owner_or_admin(discipline)
    current_user.admin? || current_user.id == discipline.user_id
  end
end
