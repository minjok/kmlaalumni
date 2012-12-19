#encoding: utf-8
class CommentsController < ApplicationController
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.posting_id = params[:posting_id]
    @comment.user_id = current_user.id
    @posting = Posting.find(params[:posting_id])
    
    if !current_user.is_member_of(@comment.posting.group)
      @comment.errors.add(:membership, "이 그룹의 멤버만 댓글을 쓸 수 있습니다")
    elsif @comment.save
      @posting.updated_at = Time.now
      @posting.save!
    end
    
    respond_to do |format|
      format.js
    end
        
  end
  
  def destroy
    comment = Comment.find(params[:id])
    @posting_id = comment.posting.id
    @comment_id = comment.id
    comment.destroy
    respond_to do |format|
      format.js
    end
  end
  
  def feed
    @comments = getComments(params)
    @posting = params[:posting]
    respond_to do |format|
      format.js
    end
  end
  
  protected
    def getComments(params)
      return Comment.where(posting_id: params[:posting]).order('created_at')
    end
end
