class ActivitiesController < ApplicationController

  def num_pages
    activities = Activity.where("is_public = ? OR venue_id IN (?)", true, current_user.groups).order('created_at DESC').page(params[:page]).per(10)  
    num_pages = activities.blank? ? 0 : activities.num_pages
    respond_to do |format|
      format.json { render json: num_pages }
    end
  end
  
  def feed
    @activities = Activity.where("is_public = ? OR venue_id IN (?)", true, current_user.groups).order('created_at DESC').page(params[:page]).per(10)  
  end
  
end
