# encoding: utf-8
class SettingsController < ApplicationController

  def get_add_education_form
    @schools = School.order('name')
    respond_to do |format|
      format.html { render partial: 'settings/add_education_form' }
    end
  end
  
  def get_add_employment_form
    @organizations = Organization.order('name')
    respond_to do |format|
      format.html { render partial: 'settings/add_employment_form' }
    end
  end
  
end
