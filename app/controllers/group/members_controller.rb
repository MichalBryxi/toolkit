class Group::MembersController < ApplicationController
  before_filter :load_group
  filter_access_to :all, attribute_check: true, model: Group

  def index
    set_page_title t('group.members.index.title', group: @group.name)

    @committee = @group.committee_members.all
    @members = @group.normal_members.all
    @pending_requests = (@group.pending_membership_requests.count > 0)
  end

  protected

  def load_group
    @group = Group.find(params[:group_id])
  end
end
