# encoding: utf-8
class SettingsController < ApplicationController
 
  # Method: update
  # --------------------------------------------
  # 
  def update
    @user = User.find(current_user.id)
    @update_attr_name = params[:user].keys.first
    @update_attr_value = params[:user][@update_attr_name]
    
    @successfully_updated = if @update_attr_name == 'password'
      @user.update_with_password(params[:user])
    else
      @user.update_without_password(params[:user])
    end
    
    sign_in @user, bypass: true if @successfully_updated
    
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
  
end
