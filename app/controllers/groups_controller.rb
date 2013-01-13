# encoding: utf-8
class GroupsController < ApplicationController


  # *** BEFORE_FILTER *** #
   
    
  # Validates that the user is an admin of the group 
  before_filter :authenticate_admin, only: [:edit, :update, :destroy] 
  
  # Loads the group with the given id in params
  before_filter :load_group, only: [:show]
  
  respond_to :html
  
  
  # *** PUBLIC METHODS *** #
  
  
  # Method: index
  # --------------------------------------------
  # Displays all groups.
  def index
    @groups = Group.find(:all)
  end
  
  # Method: new
  # --------------------------------------------
  # Displays a page to create a new group.	
  def new
    @group = Group.new
  end

  # Method: create
  # --------------------------------------------
  # Creates a new group.
  def create

    @group = Group.new(params[:group])
    
    if @group.save
      # Makes the user an admin of the new group if successfully saved
      Membership.request(current_user, @group, true)
      respond_with @group, location: group_url(@group)
    else
      respond_with @group
    end
    
  end

  # Method: edit
  # --------------------------------------------
  # Displays the edit page for a group      
  def edit
  end

  # Method: update
  # --------------------------------------------
  # Updates the group.
  def update
    if @group.update_attributes(params[:group])
      respond_with @group, location: group_url(@group)
    else
      respond_with @group
    end
  end

  # Method: show
  # --------------------------------------------
  # Displays the group page.
  def show
    membership = Membership.where('user_id = ? AND group_id = ?', current_user, @group).first
    @user_is_a_member = !membership.blank?
    @user_is_an_admin = membership.admin
  end

  # Method: destroy
  # --------------------------------------------
  # Destroys the group.
  def destroy
    @group.destroy
    redirect_to root_url
  end
  
  
  # *** PRIVATE METHODS *** #
  
  	
  protected
  
    # Method: authenticate_admin
    # --------------------------------------------
    # BEFORE_FILTER
    # Authenticates that the user is an admin of the group. 
    def authenticate_admin
      return unless load_group
      
      unless current_user.is_admin_of?(@group)
        flash[:warning] = '그룹의 관리자만 접근할 수 있습니다'
        respond_to do |format|
          format.js { render 'redirect' }
          format.html { redirect_to group_url(@group) }
        end
      end
    end
    
end
