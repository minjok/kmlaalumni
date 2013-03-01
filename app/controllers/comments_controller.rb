# encoding: utf-8
class CommentsController < ApplicationController
  
   
  # *** BEFORE_FILTER *** #
  
  before_filter :find_commentable, only: [:create, :get_comments]
    
  # Authenticates that user wrote the comment
  before_filter :authenticate_comment_author, only: [:destroy]
    
  # Loads comment with given id
  before_filter :load_comment, only: [:get_content]
  
  
  
  # *** PUBLIC METHODS *** #
  
  
  # Method: create
  # --------------------------------------------
  # Creates a comment
  def create
  
    # Creates a new comment instance
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @comment.commentable = @commentable
    
    # Sets the commentable's updated time if comment is successfully saved without errors
    if @comment.save
      @commentable.updated_at = Time.now
      @commentable.save!
    end
    
    respond_to do |format|
      format.js
    end
        
  end
  
  # Method: destroy
  # --------------------------------------------
  # Destroys a comment
  def destroy
    @commentable = @comment.commentable
    @comment.destroy
    respond_to do |format|
      format.js
    end
  end
    
  # Method: get_comments
  # --------------------------------------------
  # Fetches all comments when user clicks on
  # '댓글 모두 보기' link
  def get_comments
    # Retrieve all comments of a commentable
    @comments = @commentable.comments
    respond_to do |format|
      format.js
    end
    
  end
  
  # Method: get_content
  # --------------------------------------------
  # Returns the content of a comment
  def get_content
    respond_to do |format|
      format.js
    end
  end
    
  # *** PRIVATE METHODS *** #
  
  
  private
    
    # Method: find_commentable
    # --------------------------------------------
    # BEFORE_FILTER
    # Classifies and returns commentable instance
    def find_commentable
      @commentable = nil
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @class_name = $1.classify
          @commentable = @class_name.constantize.find(value)
        end
      end
      
      if @commentable.blank?
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { render file: 'public/404', format: :html, status: 404 }
        end
      end
    end
    
    # Method: authenticate_comment_author
    # --------------------------------------------
    # BEFORE_FILTER
    # Authenticate that the user wrote the comment.
    def authenticate_comment_author
      return unless load_comment
      
      unless current_user.wrote?(@comment)
        flash[:warning] = '댓글을 올린 사람만 삭제할 수 있습니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end
    
    end

end
