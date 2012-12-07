#encoding: utf-8
class CommentsController < ApplicationController

  respond_to :html
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.posting_id = params[:posting_id]
    @comment.user_id = current_user.id
    
    if !current_user.is_member_of(@comment.posting.group)
      @comment.errors.add(:membership, "이 그룹의 멤버만 댓글을 쓸 수 있습니다")
    end 
    
    if @comment.save
      respond_with @comment, location: group_url(@comment.posting.group)
    else
      respond_with @comment, action: group_url(@comment.posting.group)
    end
  end
  
  def destroy
  end
  
end
