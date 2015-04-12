class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :add_user, :remove_user, :search_user]
  before_action AdminOrTeacherActionCallback

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all.paginate(page: params[:page], per_page: PER_PAGE)
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_user
    @user = User.find(params[:user_id])
    @group.users.delete(@user)
    respond_to do |format|
      format.html { redirect_to @group, notice: 'Student was successfully removed.' }
      format.js
    end
  end

  def add_user
    @user = User.find(params[:user_id])
    if @user.student?
      begin
        @group.users << @user
      rescue ActiveRecord::RecordInvalid => e
        respond_to do |format|
          format.html { redirect_to @group, alert: e.message }
          format.js
        end
      else
        respond_to do |format|
          format.html { redirect_to @group, notice: 'Student was successfully added.' }
          format.js
        end
      end
    end
  end

  def search_user
    query = params[:q]
    @users = User.student.where('name LIKE ?', "%#{query}%")
    respond_to do |format|
      format.html { redirect_to @group }
      format.json { render json: @users, only: [:id, :name] }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:title)
  end
end
