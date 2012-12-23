#encoding: utf-8
class CommentsController < ApplicationController
   
  # Method: create
  # --------------------------------------------
  # Adds a comment to a posting.
  def create
  
    # Creates a new comment instance with associations
    @comment = Comment.new(params[:comment])
    @comment.posting_id = params[:posting_id]
    @comment.user_id = current_user.id
    
    # Validates that the user is a group member
    unless current_user.is_member_of(@comment.posting.group)
      @comment.errors.add(:membership, '이 그룹의 멤버만 댓글을 쓸 수 있습니다')
    end
    
    # Sets the posting's updated time if comment is successfully saved without errors
    if @comment.errors.blank? && @comment.save
      @comment.posting.updated_at = Time.now
      @comment.posting.save!
    end
    
    respond_to do |format|
      format.js
    end
        
  end
  
  # Method: destroy
  # --------------------------------------------
  # Deletes a comment of a posting.
  def destroy
  
    # Retrieves comment
    @comment = Comment.find(params[:id])
    
    # Necessary attributes for JS rendering after comment destruction
    @comment_id = @comment.id.to_s
    @destroyed = false
    
    # Validates that the user wrote the comment
    unless current_user.wrote?(@comment)
      @comment.errors.add(:ownership, '이 댓글을 삭제할 권한이 없습니다')
    end
    
    # Destroys comment if comment is successfully validated
    if @comment.valid?
      @comment.destroy
      @destroyed = true
    end
    
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
  
  def like
    @like = Like.new
    @like.user = current_user
    
    @comment = Comment.find(params[:id])
    if @comment.blank?
      @like.errors.add(:comment, '해당 댓글이 존재하지 않습니다')
    else
      @like.comment = @comment
      if Like.exists_for_comment?(current_user, @comment)
        @like.errors.add(:comment, '이미 댓글을 좋아합니다')
      end
    end
    
    @like.save if @like.errors.blank?
    
    respond_to do |format|
      format.js
    end
    
  end
  
  def dislike
  
    @destroyed = false
    @comment = Comment.find(params[:id])
    if @comment.blank?
      # TO-DO: FLASH MESSAGE FOR NO SUCH POSTING
    else
      @like = Like.where('user_id = ? AND comment_id = ?', current_user, @comment).first
      if @like.blank?
        # TO-DO: FLASH MESSAGE FOR NO SUCH LIKE
      else
        @like.destroy
        @destroyed = true
      end
    end
    
    respond_to do |format|
      format.js
    end
    
  end
  
  protected
    
    # Method: getComments
    # --------------------------------------------
    # Helper method for @feed. 
    # Retrieves all comments of a posting with the given id 
    # in the order of created time.
    def getComments(posting_id)
      Comment.where('posting_id = ?', posting_id).order('created_at')
    end
    
end
