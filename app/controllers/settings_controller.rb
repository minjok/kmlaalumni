class SettingsController < ApplicationController

  def get_form
    @section = params[:section] + "_form"
    respond_to do |format|
      format.js
    end
  end
  
end
