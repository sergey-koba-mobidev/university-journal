class DisciplinesController < ApplicationController
  include ApplicationHelper
  before_action :set_discipline, :owner_or_admin, only: [:show, :edit, :update, :destroy]
  before_action AdminOrTeacherActionCallback

  # GET /disciplines
  # GET /disciplines.json
  def index
    @disciplines = current_user.allowed_disciplines.paginate(page: params[:page], per_page: PER_PAGE)
  end

  # GET /disciplines/1
  # GET /disciplines/1.json
  def show
    unless params[:semester_id].nil?
      @semester = Semester.find(params[:semester_id])
    else
      @semester = Semester.current
    end
  end

  # GET /disciplines/new
  def new
    @discipline = Discipline.new
  end

  # GET /disciplines/1/edit
  def edit
  end

  # POST /disciplines
  # POST /disciplines.json
  def create
    if current_user.admin?
      @discipline = Discipline.new(discipline_params)
    else
      @discipline = current_user.disciplines.build(discipline_params)
    end

    respond_to do |format|
      if @discipline.save
        format.html { redirect_to @discipline, notice: 'Discipline was successfully created.' }
        format.json { render :show, status: :created, location: @discipline }
      else
        format.html { render :new }
        format.json { render json: @discipline.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /disciplines/1
  # PATCH/PUT /disciplines/1.json
  def update
    respond_to do |format|
      if @discipline.update(discipline_params)
        format.html { redirect_to @discipline, notice: 'Discipline was successfully updated.' }
        format.json { render :show, status: :ok, location: @discipline }
      else
        format.html { render :edit }
        format.json { render json: @discipline.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disciplines/1
  # DELETE /disciplines/1.json
  def destroy
    @discipline.destroy
    respond_to do |format|
      format.html { redirect_to disciplines_url, notice: 'Discipline was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_discipline
    @discipline = Discipline.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def discipline_params
    if current_user.admin?
      params.require(:discipline).permit(:title, :user_id)
    else
      params.require(:discipline).permit(:title)
    end
  end

  def owner_or_admin
    unless current_user.admin? || current_user.id == @discipline.user_id
      redirect_to :root, :alert => 'Access denied.'
    end
  end
end
