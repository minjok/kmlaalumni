# encoding: utf-8
class MembershipController < ApplicationController
	
    
  # *** BEFORE_FILTER *** #
  
  
  # Loads group with given id
  before_filter :load_group, only: [:add]
  
  # Verifies that group has admin(s) after the user leaves
  before_filter :verify_other_admins_exist, only: [:delete]
  

  # *** PUBLIC METHODS *** #
  
  
  # Method: add
  # --------------------------------------------
  # Adds the user as a member of the group.
  def add
    Membership.request(current_user, @group, false)
    redirect_to group_url(@group)
  end

  # Method: delete
  # --------------------------------------------
  # Deletes the user's membership with the group.
  def delete
    Membership.breakup(current_user, @group)
    redirect_to group_url(@group)
  end
  
  
  # *** PRIVATE METHODS *** #
  
  
  protected
    
    # Method: verify_other_admins_exist
    # --------------------------------------------
    # BEFORE_FILTER
    # Verifies on @delete that EITHER 
    # (1) the user attempting to leave is not an admin OR 
    # (2) the group has other admins
    def verify_other_admins_exist
      return unless load_group
      
      unless !current_user.is_admin_of?(@group) || @group.has_other_admins_than?(current_user)
        flash[:warning] = '소모임을 나가시기 전에 소모임의 새로운 관리자를 임명하셔야 합니다'
        respond_to do |format|
          format.js { render json: flash[:warning], status: :unauthorized }
          format.html { redirect_to group_url(@group) }
        end
      end
    end

end
