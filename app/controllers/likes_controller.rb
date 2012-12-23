# encoding: utf-8
class LikesController < ApplicationController

  def add
    @like = Like.new
    @like.user = current_user
    @like.platform = params[:platform]
    if params[:platform].to_i == Like::PLATFORM['POSTING']
      @like.posting_id = params[:id]
    elsif params[:platform].to_i == Like::PLATFORM['COMMENT']
      @like.comment_id = params[:id]
    else
      @like.errors.add(:platform, "존재하지 않는 콘텐츠를 '좋아요'할 수 없습니다")
    end
    
    @like.save if @like.valid?
    
    respond_to do |format|
      format.js
    end
    
  end
  
  def delete
  end
  
end
