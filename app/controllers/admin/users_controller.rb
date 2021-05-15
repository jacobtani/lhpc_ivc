class Admin::UsersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_user, only: %i[ show edit update destroy ]

  def index
    @users = User.order(:created_at)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "User was successfully created."
      redirect_to admin_users_url
    else
      flash[:error] = "Could not create user"
      render :new, status: :unprocessable_entity
    end
  end
   
  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated."
      redirect_to admin_users_url
    else
      flash[:error] = "Could not update user"
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @user.destroy
    flash[:notice] = "User was successfully deleted"
    redirect_to admin_users_url
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
