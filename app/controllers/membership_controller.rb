class MembershipController < ApplicationController
	
	respond_to :html
	
	def add
		@group = Group.find(params[:id])
		Membership.request(current_user, @group, false)
		respond_with @group, location: group_url(@group)
	end

	def delete
		@group = Group.find(params[:id])
		if !@group.has_other_members_than?(current_user)
			@group.destroy
			respond_with @group, location: groups_url
		elsif @group.has_other_admins_than?(current_user)
			Membership.breakup(current_user, @group)
			respond_with @group, location: group_url(@group)
		else
			respond_with @group
		end
	end

end
