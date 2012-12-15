class SettingsController < ApplicationController

  def get_update_form
    @section = params[:section] + "_update_form"
    respond_to do |format|
      format.js
    end
  end
  
end
