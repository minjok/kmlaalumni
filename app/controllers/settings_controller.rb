# encoding: utf-8
class SettingsController < ApplicationController
 
  # Method: update
  # --------------------------------------------
  # 
  def update
    @successfully_updated = false
    
    if params.has_key?(:attr) && params.has_key?(:user)
      @user = User.find(current_user.id)
      @target = params[:attr]
      
      @successfully_updated = if @target == 'password'
        @user.update_with_password(params[:user])
      else
        @user.update_without_password(params[:user])
      end
    
      if @target == 'contact_information'
        unless @user.fb.blank?
          @user.fb = url_with_protocol(@user.fb)
        end
        unless @user.tw.blank?
          @user.tw = url_with_protocol(@user.tw)
        end
        unless @user.ln.blank?
          @user.ln = url_with_protocol(@user.ln)
        end
        unless @user.blog.blank?
          @user.blog = url_with_protocol(@user.blog)
        end
      end
    
      @successfully_updated = @user.save
    
      sign_in @user, bypass: true if @successfully_updated
    end
    
    respond_to do |format|
      format.js
      format.html { redirect_to settings_url }
    end
  end
  
  # Method: get_form
  # --------------------------------------------
  # 
  def get_form
    @target = params[:type]
    @open = params[:open] == 'true'
    if params.has_key?(:id)
      @target = params[:type] + '_' + params[:id] 
      @education = Education.find(params[:id]) if params[:type] == 'education'
      @employment = Employment.find(params[:id]) if params[:type] == 'employment'
    end
    respond_to do |format|
      format.js
    end
  end
  
  # Method: get_add_education_form
  # --------------------------------------------
  # 
  def get_add_education_form
    @schools = School.order('name')
    respond_to do |format|
      format.html { render partial: 'settings/add_education_form' }
    end
  end
  
  # Method: get_add_employment_form
  # --------------------------------------------
  # 
  def get_add_employment_form
    @organizations = Organization.order('name')
    respond_to do |format|
      format.html { render partial: 'settings/add_employment_form' }
    end
  end
  
  private
    def url_with_protocol(url)
      /^https?:\/\//.match(url) ? url : "http://#{url}"
    end
end
