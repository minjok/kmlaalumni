class SettingsController < ApplicationController

  def get_form
    @section = params[:section]
    @form_container_id = params[:section]
    @form_container_id += '_' + params[:id] if params.has_key?(:id) && !params[:id].blank?
    @form_container_id += '_container'

    @education =  Education.find(params[:id]) if @section == 'update_education_form'
   
    respond_to do |format|
      format.js
    end
  end
  
end
