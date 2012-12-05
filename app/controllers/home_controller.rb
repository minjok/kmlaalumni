class HomeController < ApplicationController
	
  def index
    if user_signed_in?
      @feed_postings = Posting.where(group_id: current_user.groups).order('created_at DESC')
    else
      redirect_to :welcome
    end
  end
	
  def welcome
  end
	
end
