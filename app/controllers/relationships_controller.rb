class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:show, :destroy, :update_proportions]
  before_action AdminOrTeacherActionCallback

  def show
    @attends = Attend.where(visit_id: @relationship.visits.all).where(user_id: @relationship.group.users.all).all
  end

  def create
    @relationship = Relationship.new(relationship_params)
    if owner_or_admin(@relationship.discipline) && @relationship.save
      redirect_to :back, notice: 'Group was added to semester!'
    else
      if (!owner_or_admin(@relationship.discipline))
        redirect_to :back, alert: 'Access denied!'
      else
        redirect_to :back, alert: @relationship.errors.full_messages.join(". ")
      end
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

  def update_proportions
    @relationship.proportions = params[:total]
    if @relationship.save
      redirect_to :back, notice: 'Total is saved!'
    else
      redirect_to :back, alert: 'Total is NOT saved!'
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
