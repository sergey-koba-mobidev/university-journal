class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:show, :destroy]
  before_action AdminOrTeacherActionCallback

  def show

  end

  def create
    @relationship = Relationship.new(relationship_params)
    if owner_or_admin(@relationship.discipline) && @relationship.save
      redirect_to :back, notice: 'Group was added to semester!'
    else
      redirect_to :back, alert: 'Access denied!'
    end
  end

  def destroy
    if owner_or_admin(@relationship.discipline)
      @relationship.destroy
      redirect_to :back, notice: 'Group was deleted from semester!'
    else
      redirect_to :back, alert: 'Access denied!'
    end
  end

  private

  def set_relationship
    @relationship = Relationship.find(params[:id])
  end

  def relationship_params
    params.require(:relationship).permit(:semester_id, :discipline_id, :group_id)
  end
end
