class DisciplineModulesController < ApplicationController
  before_action :set_relationship, only: [:index]
  before_action AdminOrTeacherActionCallback
  layout "tickets", only: [:do_generate_tickets]

  def index
    @discipline_modules = @relationship.discipline.discipline_modules
    @module_visits = @relationship.visits.where(kind: Visit.kinds[:module])
  end
  
  def generate_tickets
    @discipline_module = DisciplineModule.find(params[:id])
  end

  def do_generate_tickets
    @discipline_module = DisciplineModule.find(params[:id])
    @tickets = DisciplineModule::GenerateTickets.(
      params: { tickets_count: params[:tickets_count], discipline_module: @discipline_module }, 
      current_user: current_user)[:tickets]
  end

  private

  def set_relationship
    @relationship = Relationship.find(params[:relationship_id])
  end
end
