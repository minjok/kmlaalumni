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
		elsif !current_user.is_admin_of(@group)
			Membership.breakup(current_user, @group)
			respond_with @group, location: group_url(@group)
		elsif !@group.has_other_admins_than?(current_user)
			@group.errors.add(:membership, "소모임을 나가시기 전에 소모임의 새로운 관리자를 선임하셔야 합니다")
			respond_with @group
		end
		
	end

end
