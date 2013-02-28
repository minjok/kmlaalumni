#encoding: utf-8
class CareersController < ApplicationController

  before_filter :authenticate_careernote_authority, only: [:create_note, :get_note_form, :update_note, :destroy_note]
  before_filter :validate_employment_has_no_careernote, only: [:create_note]
  before_filter :validate_employment_has_careernote, only: [:get_note_form, :update_note]

  def show_notes
    @user = User.find(params[:id])
    @careernotes = @user.careernotes
  end
  
  def write_notes
    @employments = current_user.employments
  end
  
  def create_note
    @careernote = Careernote.new(params[:careernote])
    @careernote.employment = @employment
    @careernote.save
    respond_to do |format|
      format.js { render 'careers/write_note.js' }
    end
  end
  
  def update_note
    @careernote = @employment.careernote
    @careernote.update_attributes(params[:careernote])
    @careernote.save
    respond_to do |format|
      format.js { render 'careers/write_note.js' }
    end
  end
  
  def destroy_note
    @employment.careernote.destroy
    respond_to do |format|
      format.js
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
