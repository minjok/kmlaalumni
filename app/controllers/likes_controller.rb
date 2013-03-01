#encoding: utf-8
class LikesController < ApplicationController

  before_filter :find_likeable
  before_filter :verify_user_dislikes_likeable, only: [:create]
  before_filter :verify_user_likes_likeable, only: [:destroy]
  
  # Method: create
  # --------------------------------------------
  # Creates a like
  def create
    @like = Like.new
    @like.user = current_user
    @like.likeable = @likeable
    @like.save
    respond_to do |format|
      format.js
    end
  end
  
  # Method: dislike
  # --------------------------------------------
  # Destroy a like
  def destroy
    @like.destroy
    respond_to do |format|
      format.js
    end
  end
  
  # Method: get_likes
  # --------------------------------------------
  # Returns the content of a likeable
  def get_likes
    @likes = @likeable.likes
    @class_name = translate_class_name(@likeable.class.name)
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
          @likeable = $1.classify.constantize.find(value)
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
    # Verifies that the user likes the likeable
    def verify_user_likes_likeable
      @like = Like.where('user_id = ? AND likeable_id = ? AND likeable_type = ?', current_user, @likeable, @likeable.class.name).first
      if @like.blank?
        flash[:warning] = '이미 콘텐츠를 좋아하지 않습니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end
    end
    
    def translate_class_name(class_name)
      if class_name == 'Posting'
        '포스팅'
      elsif class_name == 'Comment'
        '댓글'
      else
        '콘텐츠'
      end
    end
  
end
