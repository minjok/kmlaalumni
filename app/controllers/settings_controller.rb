class SettingsController < ApplicationController

  def get_form
    @section = params[:section]
    @form_container_id = params[:section]
    if params.has_key?(:id) && !params[:id].blank?
      @form_container_id += '_' + params[:id]
      @education =  Education.find(params[:id]) if @section == 'update_education_form'
      @employment = Employment.find(params[:id]) if @section == 'update_employment_form'
    end
    @form_container_id += '_container'

    
    
    respond_to do |format|
      format.js
    end
  end
  
end
