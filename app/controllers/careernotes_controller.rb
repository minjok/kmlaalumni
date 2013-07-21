#encoding: utf-8
class CareernotesController < ApplicationController

  # *** BEFORE_FILTER *** #
  
  #
  before_filter :authenticate_employment_authority, only: [:new, :create]
  
  #
  before_filter :authenticate_careernote_authority, only: [:edit, :update, :destroy]
  
  #
  before_filter :load_careernote, only: [:show, :get_content]
  
  #
  before_filter :validate_employment_has_no_careernote, only: [:new, :create]
  
  #
  before_filter :validate_employment_has_careernote, only: [:edit, :update, :destroy]
  
  # *** METHODS *** #
  
  # Method: index
  # --------------------------------------------
  #
  def index
    @tags=get_tags("Careernote")
  end
  
  # Method:
  # --------------------------------------------
  #
  def dashboard
    @employments = current_user.employments
  end
  
  # Method: new
  # --------------------------------------------
  #
  def new
    @careernote = Careernote.new
  end
  
  # Method: create
  # --------------------------------------------
  #
  def create
    @careernote = Careernote.new(params[:careernote])
    @careernote.user = current_user
    @careernote.employment = @employment
    @careernote.save
    respond_to do |format|
      format.js { render 'submit' }
    end
  end
  
  # Method: edit
  # --------------------------------------------
  #
  def edit
  end
  
  # Method: update
  # --------------------------------------------
  #
  def update
    @careernote.update_attributes(params[:careernote])
    respond_to do |format|
      format.js  { render 'submit' }
    end
  end
  
  # Method: show
  # --------------------------------------------
  #
  def show
    @tags=@careernote.tags.sort { |x,y| x.name <=> y.name }
    respond_to do |format|
      format.html
    end
  end
  
  # Method: destroy
  # --------------------------------------------
  #
  def destroy
    @careernote.destroy
    respond_to do |format|
      format.js { render 'submit' }
    end
  end
  
  # Method: num_pages
  # --------------------------------------------
  #    
  def num_pages
    careernotes = Careernote.order('created_at DESC').page(params[:page]).per(10)
    num_pages = careernotes.blank? ? 0 : careernotes.num_pages
    respond_to do |format|
      format.json { render json: num_pages }
    end
  end
  
  # Method: feed
  # --------------------------------------------
  #
  def feed
    @careernotes = Careernote.order('created_at DESC').page(params[:page]).per(6)
    respond_to do |format|
      format.js
    end
  end
  
  # Method: get_content
  # --------------------------------------------
  #
  def get_content
    respond_to do |format|
      format.js
    end
  end
  
  private
    
    # Method: authenticate_employment_authority
    # --------------------------------------------
    #
    def authenticate_employment_authority
      return unless load_employment
      unless @employment.user == current_user
        flash[:warning] = '다른 동문의 직장 경력을 수정할 수 없습니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end      
    end
    
    # Method: authenticate_careernote_authority
    # --------------------------------------------
    #
    def authenticate_careernote_authority
      return unless load_careernote
      @employment = @careernote.employment
      unless @careernote.user == current_user
        flash[:warning] = '다른 동문의 직장 경력을 수정할 수 없습니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end      
    end
    
    # Method: validate_employment_has_no_careernote
    # --------------------------------------------
    #
    def validate_employment_has_no_careernote
      @careernote = @employment.careernote
      unless @careernote.blank?
        flash[:warning] = '이미 커리어 노트를 쓰셨습니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end
    end
    
    # Method: validate_employment_has_careernote
    # --------------------------------------------
    #
    def validate_employment_has_careernote
      @careernote = @employment.careernote
      if @careernote.blank?
        flash[:warning] = '커리어 노트가 없습니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end
    end
    
end
