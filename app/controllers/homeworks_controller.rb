class HomeworksController < ApplicationController
  before_action :set_visit, except: [:update, :destroy]
  before_action :set_user, except: [:update, :destroy]
  before_action :check_access
  before_action AdminOrTeacherActionCallback, only: [:update, :destroy]

  MAX_HOMEWORKS = 10

  def index
    @homeworks = @user.homeworks.where(visit_id: @visit.id).order('created_at desc')
  end

  def show
    @homework = Homework.new(user_id: @user.id)
  end

  def new
    @homework = Homework.new
  end

  def update
    @homework = Homework.find(params[:id])
    @homework.body = params[:homework][:body] if params[:homework][:body]
    if @homework.save
      #Notify student
      UserMailer.new_correction_email(@homework).deliver_now

      redirect_to :back, notice: 'Correction was updated.'
    else
      redirect_to :back, alert: 'Can\'t update correction.'
    end

  end

  def destroy
    @homework = Homework.find(params[:id])
    if @homework.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Homework was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, alert: @homework.errors.full_messages.join('. ')}
        format.json { render @homework.errors }
      end
    end
  end

  def create
    hm_count = @user.homeworks.where(visit_id: @visit.id).count
    redirect_to :root, :alert => 'Access denied. Too many Homeworks!' if hm_count == MAX_HOMEWORKS

    @homework = Homework.new(homework_params)
    @homework.user = @user
    @homework.visit = @visit

    respond_to do |format|
      if @homework.save
        #Notify teacher
        UserMailer.new_homework_email(@homework).deliver_now

        format.html { redirect_to visit_homeworks_path(visit_id: @visit.id, user_id: @user.id), notice: 'Homework was successfully created.' }
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
    @attend = Attend.find_by_visit_id_and_user_id(params[:visit_id], params[:user_id])
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