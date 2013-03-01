#encoding: utf-8
class LikesController < ApplicationController

  before_filter :find_likeable
  before_filter :verify_user_dislikes_likeable, only: [:like]
  before_filter :verify_user_likes_likeable, only: [:dislike]
  
  def like
    @like = Like.new
    @like.user = current_user
    @like.likeable = @likeable
    @like.likeable_type = @type
    @like.save
    respond_to do |format|
      format.js { render @type.downcase.pluralize + '/like' }
    end
  end
  
  def dislike
    @like.destroy
    respond_to do |format|
      format.js { render @type.downcase.pluralize + '/dislike' }
    end
  end
  
  # Method: get_likes
  # --------------------------------------------
  # Returns the content of a posting
  def get_likes
    @likes = Like.where('likeable_id = ?', @likeable)
    @type = translate_type(@likeable.class.name)
    respond_to do |format|
      format.js
    end
  end
  
  private
    
    # Method: find_likeable
    # --------------------------------------------
    # BEFORE_FILTER
    # Classifies and returns likeable instance
    def find_likeable
      @likeable = nil
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @type = $1.classify
          @likeable = @type.constantize.find(value)
        end
      end
      
      if @likeable.blank?
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { render file: 'public/404', format: :html, status: 404 }
        end
      end
    end
    
    # Method: verify_user_dislikes_likeable
    # --------------------------------------------
    # BEFORE_FILTER
    # Verifies that the user doesn't like the likeable
    def verify_user_dislikes_likeable
      if current_user.likes?(@likeable)
        flash[:warning] = '이미 콘텐츠를 좋아합니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end
    end
    
    # Method: verify_user_likes_likeable
    # --------------------------------------------
    # BEFORE_FILTER
    # Verifies that the user doesn't like the likeable
    def verify_user_likes_likeable
      @like = Like.where('user_id = ? AND likeable_id = ?', current_user, @likeable).first
      if @like.blank?
        flash[:warning] = '이미 콘텐츠를 좋아하지 않습니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end
    end
    
    def translate_type(type)
      if type == 'Posting'
        '포스팅'
      elsif type == 'Comment'
        '댓글'
      else
        '콘텐츠'
      end
    end
  
end
