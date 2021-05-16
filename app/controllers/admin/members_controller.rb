class Admin::MembersController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_member, only: %i[ show edit update destroy children ]

  def index
    @members = Member.active.adult.order(:created_at)
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      flash[:notice] = "Member was successfully created."
      redirect_to admin_members_url
    else
      flash[:error] = "Could not create member"
      render :new, status: :unprocessable_entity
    end
  end
   
  def edit
  end

  def update
    if @user.update(member_params)
      flash[:notice] = "Member was successfully updated."
      redirect_to admin_users_url
    else
      flash[:error] = "Could not update member"
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @member.destroy
    flash[:notice] = "Member was successfully deleted"
    redirect_to admin_members_url
  end

  def children
    @children = Member.children.where(parent_id: @member.id)
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.require(:member).permit(:family_id, first_name, :surname, :dob, :date_joined, :date_left, :has_caregiver)
  end
end
