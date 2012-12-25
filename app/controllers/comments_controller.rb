# encoding: utf-8
class CommentsController < ApplicationController
  
   
  # *** BEFORE_FILTER *** #
  
  
  # Loads the posting with given id
  before_filter :load_posting, only: [:create]
  
  # Authenticates that user wrote the comment
  before_filter :authenticate_comment_author, only: [:destroy]
  
  # Verifies that the user doesn't like the comment
  before_filter :verify_user_dislikes_comment, only: [:like]
  
  # Verifies that the user likes the comment
  before_filter :verify_user_likes_comment, only: [:dislike]
  
  
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
  
  # Method: like
  # --------------------------------------------
  # Creates a Like instance for the user and comment.
  def like
    @like = Like.new
    @like.user = current_user
    @like.comment = @comment
    @like.save
    
    respond_to do |format|
      format.js
    end
    
  end
  
  # Method: dislike
  # --------------------------------------------
  # Destroys the Like instance between the user and comment.
  def dislike
    @like.destroy
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
  
  
  # *** PRIVATE METHODS *** #
  
  
  protected
    
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
        redirect_to root_url
        return
      end
    
    end
    
     # Method: verify_user_likes_comment
    # --------------------------------------------
    # BEFORE_FILTER
    # Verify that the user likes the comment.
    def verify_user_likes_comment
      return unless load_comment
      
      @like = Like.where('user_id = ? AND comment_id = ?', current_user, @comment).first
      
      unless !@like.blank?
        flash[:warning] = '이미 댓글을 좋아하지 않습니다'
        redirect_to root_url
        return
      end
      
    end
    
    # Method: verify_user_dislikes_comment
    # --------------------------------------------
    # BEFORE_FILTER
    # Verify that the user doesn't like the comment.
    def verify_user_dislikes_comment
      
      return unless load_comment
      
      if current_user.likes?(@comment)
        flash[:warning] = '이미 댓글을 좋아합니다'
        redirect_to root_url
        return
      end
      
    end
    
    # Method: load_posting
    # --------------------------------------------
    # BEFORE_FILTER 
    # Load posting with given posting_id.
    def load_posting
     
      if params.has_key?(:posting_id)
        @posting = Posting.find_by_id(params[:posting_id])
      end
      
      if @posting.blank?
        flash[:warning] = '포스팅이 존재하지 않습니다'
        redirect_to root_url
        return false
      end
      
      return true
      
    end
    
    # Method: load_comment
    # --------------------------------------------
    # BEFORE_FILTER
    # Load comment with given id.
    def load_comment
     
      if params.has_key?(:id)
        @comment = Comment.find_by_id(params[:id])
      end
      
      if @comment.blank?
        flash[:warning] = '댓글이 존재하지 않습니다'
        redirect_to root_url
        return false
        
      end
      
      return true
      
    end
        
end
