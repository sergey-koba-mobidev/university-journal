class RelationshipsController < ApplicationController
  before_action :set_relationship, only: [:show, :destroy, :update_proportions, :total]
  before_action AdminOrTeacherActionCallback, except: [:show, :total]
  before_action

  def show
    params[:kind] = :lab if params[:kind].nil?
    @attends = Attend.where(visit_id: @relationship.visits.all).where(user_id: @relationship.group.users.all).all
  end

  def total
    @attends = Attend.where(visit_id: @relationship.visits.all).where(user_id: @relationship.group.users.all).all
    render partial: 'total', locals: { relationship: @relationship }
  end

  def create
    @relationship = Relationship.new(relationship_params)
    if owner_or_admin(@relationship.discipline) && @relationship.save
      redirect_back fallback_location: root_path, notice: 'Group was added to semester!'
    else
      if (!owner_or_admin(@relationship.discipline))
        redirect_back fallback_location: root_path, alert: 'Access denied!'
      else
        redirect_back fallback_location: root_path, alert: @relationship.errors.full_messages.join(". ")
      end
    end
  end

  def destroy
    if owner_or_admin(@relationship.discipline)
      @relationship.destroy
      redirect_back fallback_location: root_path, notice: 'Group was deleted from semester!'
    else
      redirect_back fallback_location: root_path, alert: 'Access denied!'
    end
  end

  def update_proportions
    @relationship.proportions = params[:total]
    if @relationship.save
      redirect_to relationship_path(@relationship, kind: :total), notice: 'Total is saved!'
    else
      redirect_to relationship_path(@relationship, kind: :total), alert: 'Total is NOT saved!'
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
