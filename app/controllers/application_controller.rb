# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery 
  
  # Authenticates whether user is logged in for every request
  before_filter :authenticate_user!
  
  
  # *** BEFORE_FILTER HELPER METHODS *** #
  
  
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
        format.js { render 'redirect' }
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
        format.js { render 'redirect' }
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
        format.js { render 'redirect' }
        format.html { render file: 'public/404', format: :html, status: 404 }
      end
      return false
    end
      
    return true

  end
  
end
