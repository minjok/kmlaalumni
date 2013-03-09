# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery 
  
  # Authenticates whether user is logged in for every request
  before_filter :authenticate_user!
  
  # Sets the Time.zone to the local timezone that the user is in
  before_filter :set_timezone 
  
  
  # *** BEFORE_FILTER *** #
  
  
  # Method: load_group
  # --------------------------------------------
  # Loads group with the given id in params.
  def load_group
    
    @group = nil
    
    if params.has_key?(:id)
      @group = Group.find_by_id(params[:id])
    elsif params.has_key?(:group_id)
      @group = Group.find_by_id(params[:group_id])
    end
    
    if @group.blank?
      respond_to do |format|
        format.js { render 'layouts/redirect' }
        format.html { render file: 'public/404', format: :html, status: 404 }
      end
      return false
    end
      
    return true
    
  end
    
  # Method: load_post
  # --------------------------------------------
  # Loads posting with the given id
  def load_posting
    @posting = nil
    if params.has_key?(:id)
      @posting = Posting.find_by_id(params[:id])
    elsif params.has_key?(:posting_id)
      @posting = Posting.find_by_id(params[:posting_id])
    end
    if @posting.blank?
      respond_to do |format|
        format.js { render 'layouts/redirect' }
        format.html { render file: 'public/404', format: :html, status: 404 }
      end
      return false
    end
    return true      
  end
  
  # Method: load_comment
  # --------------------------------------------
  # Load comment with given id.
  def load_comment
    @comment = nil
    if params.has_key?(:id)
      @comment = Comment.find_by_id(params[:id])
    elsif params.has_key?(:comment_id)
      @comment = Comment.find_by_id(params[:comment_id])
    end
    if @comment.blank?
      respond_to do |format|
        format.js { render 'layouts/redirect' }
        format.html { render file: 'public/404', format: :html, status: 404 }
      end
      return false
    end
    return true

  end
  
  # Method: load_employment
  # --------------------------------------------
  # Load employment with given id.
  def load_employment
    @employment = nil
    if params.has_key?(:id)
      @employment = Employment.find_by_id(params[:id])
    elsif params.has_key?(:employment_id)
      @employment = Employment.find_by_id(params[:employment_id])
    end
    if @employment.blank?
      respond_to do |format|
        format.js { render 'layouts/redirect' }
        format.html { render file: 'public/404', format: :html, status: 404 }
      end
      return false
    end
    return true
  end
  
  # Method: authenticate_posting_authority
  # --------------------------------------------
  # BEFORE_FILTER
  # Authenticates that user is authorized to post on the given platform
  def authenticate_posting_authority
    
    # Checks that posting for a group and loads group
    if params.has_key?(:posting) && params[:posting].has_key?(:platform)
      if params[:posting][:platform] == Posting::PLATFORM['GROUP'].to_s
        return unless load_group
        # Checks that user is a group member
        unless current_user.is_member_of?(@group)
          flash[:warning] = '그룹의 멤버만 포스팅을 올릴 수 있습니다'
          respond_to do |format|
            format.js { render 'layouts/redirect' }
            format.html { redirect_to group_url(@group) }
          end
        end
      elsif params[:posting][:platform] == Posting::PLATFORM['ANNOUNCEMENT'].to_s 
        # Checks that user is an admin
        unless current_user.is_admin?
          flash[:warning] = '운영자만 공지사항을 올릴 수 있습니다'
          respond_to do |format|
            format.js { render 'redirect' }
            format.html { redirect_to root_url }
          end
        end
      end
    end
  end
  
  private
    
    # Method: set_timezone
    # --------------------------------------------
    # BEFORE_FILTER
    # Sets Time.zone with the timezone variable in cookie
    def set_timezone
      Time.zone = cookies["time_zone"]
    end
    
end
