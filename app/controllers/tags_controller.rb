# encoding: utf-8
class TagsController < ApplicationController
   # *** BEFORE_FILTER *** #  
  before_filter :find_taggable, only: :create
  
  def add_tag_button
    respond_to do |format|
      format.js
    end
  end
  
  def create
    if check_tagging == false            #If same tagging exists, send error and quit
      @uniq_error=true
      respond_to do |format|
	format.js
      end
    else
      @tagging = Tagging.new
      @tagging.tag = @tag
      @tagging.tagger = current_user
    
      @tagging.taggable = @taggable
      
      # Sets the commentable's updated time if comment is successfully saved without errors
      
      respond_to do |format|
	if @tag_new == true
	  if @tag.save && @tagging.save
	    @tagging.created_at = Time.now
	  end
	else
	  if @tagging.save
	    @tagging.created_at = Time.now
	  end
	end		  
	format.js
      end  
    end
  end
  
  private
  # *** Check if same tagging exists  **#
  def check_tagging    
    @tag_new = false    
    @tag= Tag.where('name = ?', Tag.new(params[:tag]).name).first
    
    if @tag.blank?      
      @tag = Tag.new(params[:tag])
      @tag_new = true
    end
    unless @tag_new==true
      @taggable.taggings.each do |t|
	if (t.tag_id==@tag.id)
	  return false
	end
      end
    end
    return true
  end
  
  # *** Get Taggable Object  **#
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
