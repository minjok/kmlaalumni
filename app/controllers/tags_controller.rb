# encoding: utf-8
class TagsController < ApplicationController
  def add_tag_button
    respond_to do |format|
      format.js
    end
  end
  
  def check_tag
    
  end
  
  def create
    find_taggable
    @tag = Tag.new(params[:tag])
    @tagging = Tagging.new
    @tagging.tag = @tag
    @tagging.tagger = current_user
  
    @tagging.taggable = @taggable
    
    # Sets the commentable's updated time if comment is successfully saved without errors
    
    respond_to do |format|
      if @tag.save && @tagging.save
      	@tagging.created_at = Time.now
      end
      
      format.js
    end  
  end
  private
  def find_taggable
      @taggable= nil
      params.each do |name, value|
	if name =~  /(.+)_id$/
	  @class_name = $1.classify
	  @taggable = @class_name.constantize.find(value)
	end
      end
      
      if @taggable.blank?
	respond_to do |format|
	  format.js { render 'layouts/redirect' }
	  format.html { render file: 'public/404', format: :html, status: 404 }
	end
      end
     end
    
end
