# encoding: utf-8
class TagsController < ApplicationController
   autocomplete :tag, :name, full:true  
   # *** BEFORE_FILTER *** #  
  before_filter :find_taggable, only: :create
  before_filter :find_taggables_from_tag, only: :show
  
  def index 
    @tags = Tag.all
    @taggings = Tagging.order('created_at DESC').all
    respond_to do |format|
      format.html
    end
  end
  
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
   
  #** Before_filter find_taggables_from_tag to get all taggables of tag to @taggables **#

  def show
    @tags=get_tags("all")
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  #** When current_user press '좋아요' **#
  def tag_user
    @tag = Tag.find(params[:id])
    @taggable=current_user
    @tagging = Tagging.new
    @tagging.tag = @tag
    @tagging.tagger = current_user
    @tagging.taggable = @taggable
    
    respond_to do |format|
      if @tagging.save
	@tagging.created_at = Time.now
      end
      format.html { redirect_to tag_path(@tag)}   
    end
  end
  
  #** When current_user press '좋아요 취소' **#
  def detag_user
    @tag = Tag.find(params[:id])
    @taggable=current_user
    @tagging=Tagging.where({taggable_type: "User", taggable_id: current_user.id, tag_id:@tag.id}).first
    @tagging.destroy	
    respond_to do |format|
      format.html { redirect_to tag_path(@tag)}   
    end
  end
  
  private
   
  
  def find_taggables_from_tag
    @tag = Tag.find(params[:id])
    @taggings = @tag.taggings
    @taggables=[]
    @taggings.each do |tagging|	
      class_name = tagging.taggable_type.classify
      taggable = class_name.constantize.find(tagging.taggable_id)
      @taggables << [tagging.taggable, class_name]
    end
    @taggables.uniq{|x| x[0].id}
    categorize_taggables
  end
  
  # *** Categorize & Paginate Taggables to Careernote, User, etc. **#
  def categorize_taggables
    @careernotes=[]
    @users=[]
    @taggables.each do |x|
      @careernotes << x[0] if (x[1]=="Careernote") 
      @users << x[0] if (x[1]=="User")	
    end
  end
  
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
