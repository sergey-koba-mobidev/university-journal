class HomeworksController < ApplicationController
  before_action :set_visit
  before_action :set_user
  before_action :check_access

  MAX_HOMEWORKS = 10

  def index
    @homeworks = @user.homeworks.where(visit_id: @visit.id)
  end

  def show
    @homework = Homework.new(user_id: @user.id)
  end

  def new
    @homework = Homework.new
  end

  def create
    hm_count = @user.homeworks.where(visit_id: @visit.id).count
    redirect_to :root, :alert => 'Access denied.' if hm_count == MAX_HOMEWORKS

    @homework = Homework.new(homework_params)
    @homework.user = @user
    @homework.visit = @visit

    respond_to do |format|
      if @homework.save
        format.html { redirect_to visit_homeworks_path(visit_id: @visit.id, user_id: @user.id), notice: 'Discipline was successfully created.' }
        format.json { render :show, status: :created, location: visit_homeworks_path(visit_id: @visit.id, user_id: @user.id) }
      else
        format.html { render :new }
        format.json { render json: @homework.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def homework_params
    params.permit(:document, :comment_text)
  end

  def set_visit
    @visit = Visit.find(params[:visit_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def check_access
    unless user_signed_in? && (current_user.admin? || current_user.teacher? || current_user.id == @user.id)
      redirect_to :root, :alert => 'Access denied.'
    end
  end
end