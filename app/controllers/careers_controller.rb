#encoding: utf-8
class CareersController < ApplicationController

  before_filter :authenticate_careernote_authority, only: [:create_note, :get_note_form, :update_note, :destroy_note, :write_note]
  before_filter :validate_employment_has_no_careernote, only: [:create_note]
  before_filter :validate_employment_has_careernote, only: [:get_note_form, :update_note]
  
  def show
    @careernote=Careernote.find(params[:id])           # :id = employment.id
    @employment = @careernote.employment
    @user = User.find(@employment.user_id)
  end
  
  def new
    @careernote = Careernote.new
    @employment = Employment.find(params[:id])          # :id = employment.id
    @type= 'create'
    #@placeholder = employment.organization.name + '에서 어떤 일을 하셨나요?'
  end
  
  def submit_note
  	@user = current_user
  	@employments = @user.employments
	@employments_without_careernote =[]
	@organization_name =[]
	
	for employment in @employments
      if employment.careernote.blank?
        @employments_without_careernote << employment
      end
	end
  end
    
  def create
    @careernote = Careernote.new(params[:careernote])      # :id = careernote.id
    respond_to do |format|
       if @careernote.save
    	  format.html{ redirect_to submit_careernote_url }
       else
          format.html{ redirect_to root_url }
       end
    end    
  end
  
  def edit
    @careernote = Careernote.find(params[:id])             # :id = careernote.id
    @employment = @careernote.employment
  end
  
  def update
    @type= 'update' 	  
    @careernote = Careernote.find(params[:id])
    @employment = @careernote.employment
    @careernote.update_attributes(params[:careernote])
    @careernote.save
    respond_to do |format|
      format.html{ redirect_to show_careernote_url(@careernote) } 
    end
  end
  
  def destroy
    @employment = Employment.find(params[:id])	    	  
    @employment.careernote.destroy
    respond_to do |format|
      format.html{ redirect_to "/profile/#{current_user.id}"} 
    end
  end
  
  def get_note_form
    @careernote = @employment.careernote
    respond_to do |format|
      format.js
    end
  end
  
  def notes_num_pages
    careernotes = Careernote.order('created_at DESC').page(params[:page]).per(10)
    num_pages = careernotes.blank? ? 0 : careernotes.num_pages
    respond_to do |format|
      format.json { render json: num_pages }
    end
  end
  
  def notes_feed
    @careernotes = Careernote.order('created_at DESC').page(params[:page]).per(10)
    respond_to do |format|
      format.js
    end
  end
  
  private
  
    def authenticate_careernote_authority
      return unless load_employment
      unless @employment.user == current_user
        flash[:warning] = '남의 직장 경력을 수정할 수 없습니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end      
    end
    
    def validate_employment_has_no_careernote
      unless @employment.careernote.blank?
        flash[:warning] = '이미 직업 소개글을 쓰셨습니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end
    end
    
    def validate_employment_has_careernote
      if @employment.careernote.blank?
        flash[:warning] = '이미 직업 소개글을 쓰셨습니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end
    end
    
end
