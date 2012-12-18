class SettingsController < ApplicationController

  def get_form
    @section = params[:section]
    @form_container = params[:section]
    @education = nil
    
    if params[:id] 
      @form_container += "_" + params[:id]
      if @section == 'update_education_form'
        @education = Education.find(params[:id])
      end
    end
    
    respond_to do |format|
      format.js
    end
  end
  
end
