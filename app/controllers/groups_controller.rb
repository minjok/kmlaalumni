class GroupsController < ApplicationController

	respond_to :html
	
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
		respond_with @group
	end
	
	def update
		@group = Group.find(params[:id])
		# VERIFY USER IS AN ADMIN OF THIS GROUP
		if @group.update_attributes(params[:group])
			respond_with @group, location: group_url(@group)
		else
			respond_with @group
		end
	end
	
	def show
		@group = Group.find(params[:id])
		@membership = Membership.where("user_id = ? AND group_id = ?", current_user, @group).first
	end
	
	def destroy
		if @group = Group.find(params[:id])
			@group.destroy
			respond_with @group, location: groups_url
		end
	end
	
end
