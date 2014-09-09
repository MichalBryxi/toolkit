class Group::MembershipsController < ApplicationController
  before_filter :load_group
  filter_access_to :all, attribute_check: true, model: Group

  def new
    @membership = @group.memberships.new
    @membership.build_user
  end

  def create
    @membership = @group.memberships.new(params[:group_membership])

    if @membership.save
      if @membership.user.accepted_or_not_invited?
        Notifications.added_to_group(@membership).deliver
      end
      redirect_to group_members_path
    else
      render :new
    end
  end

  def edit
    @membership = @group.memberships.find(params[:id])
  end

  def update
    @membership = @group.memberships.find(params[:id])

    if @membership.update_attributes(params[:group_membership])
      set_flash_message(:success)
      redirect_to group_members_path
    else
      set_flash_message(:failure)
      render :edit
    end
  end

  def destroy
    @membership = @group.memberships.find(params[:id])

    if @membership.destroy
      set_flash_message(:success)
    else
      set_flash_message(:failure)
    end

    redirect_to group_members_path
  end

  protected

  def load_group
    @group = Group.find(params[:group_id])
  end
end
