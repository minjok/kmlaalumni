# encoding: utf-8
class CommentsController < ApplicationController
  
   
  # *** BEFORE_FILTER *** #
  
  
  # Loads the posting with given id
  before_filter :load_posting, only: [:create]
  
  # Authenticates that user is a member of group
  before_filter :authenticate_posting_authority, only: [:create]
  
  # Authenticates that user wrote the comment
  before_filter :authenticate_comment_author, only: [:destroy]
    
  # Loads comment with given id
  before_filter :load_comment, only: [:get_content]
  
  # *** PUBLIC METHODS *** #
  
  
  # Method: create
  # --------------------------------------------
  # Adds a comment to a posting.
  def create
  
    # Creates a new comment instance
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @comment.posting = @posting
    
    # Sets the posting's updated time if comment is successfully saved without errors
    if @comment.save
      @posting.updated_at = Time.now
      @posting.save!
    end
    
    respond_to do |format|
      format.js
    end
        
  end
  
  # Method: destroy
  # --------------------------------------------
  # Deletes a comment of a posting.
  def destroy
    @comment.destroy
    respond_to do |format|
      format.js
    end
  end
    
  # Method: feed
  # --------------------------------------------
  # Renders all comments for a posting when user clicks on
  # '댓글 모두 보기' link
  def feed

    # Retrieve all comments of the posting
    @comments = getComments(params[:posting_id])
    @posting_id = params[:posting_id]
    
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
    
    # Method: getComments
    # --------------------------------------------
    # HELPER METHOD for @feed. 
    # Retrieves all comments of a posting with the given id 
    # in the order of created time.
    def getComments(posting_id)
      Comment.where('posting_id = ?', posting_id).order('created_at')
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
