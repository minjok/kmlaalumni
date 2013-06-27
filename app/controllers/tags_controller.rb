# encoding: utf-8
class TagsController < ApplicationController
  def add_tag_button
    @tag = Tag.new
    respond_to do |format|
      format.js
    end
  end
  
  def add_tag
    @taggable = find_taggable
    @tag = Tag.new(params[:tag])
    @tagging = Tagging.new
    @tagging.tag = @tag
    @tagging.tagger = current_user
    @tagging.taggable = @taggable
    
    # Sets the commentable's updated time if comment is successfully saved without errors
    if @tag.save && @tagging.save
      	@tagging.created_at = Time.now
    	respond_to do |format|
    	  format.js
    	end  
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
