class DisciplineModulesController < ApplicationController
  before_action :set_relationship, only: [:index]
  before_action AdminOrTeacherActionCallback

  def index
    @discipline_modules = @relationship.discipline.discipline_modules
    @module_visits = @relationship.visits.where(kind: Visit.kinds[:module])
  end

  private

  def set_relationship
    @relationship = Relationship.find(params[:relationship_id])
  end
end
