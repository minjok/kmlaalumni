class GroupsController < ApplicationController

	respond_to :html
	
	#### TO-DO: RECORD_NOT_FOUND RESCUE ####
	
	def index
		@groups = Group.find(:all)
	end
	
	def new
		@group = Group.new
	end
	
	def create
		@group = Group.new(params[:group])
		if @group.save
			Membership.request(current_user, @group, true)
			respond_with @group, location: group_url(@group)
		else
			respond_with @group
		end
	end
		
	def edit
		@group = Group.find(params[:id])
	end
	
	def update
		@group = Group.find(params[:id])
		if @group.has_admin?(current_user) && @group.update_attributes(params[:group])
			respond_with @group, location: group_url(@group)
		else
			respond_with @group
		end
	end
	
	def show
		@group = Group.find(params[:id])
		@membership = Membership.where("user_id = ? AND group_id = ?", current_user, @group).first
        @comment = Comment.new
    end
	
	def destroy
		@group = Group.find(params[:id])
		if !@group.blank? && current_user.is_admin_of(@group)
			@group.destroy
			respond_with @group, location: groups_url
		end
	end
	
end
