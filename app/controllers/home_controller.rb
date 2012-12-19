class HomeController < ApplicationController
  
  skip_before_filter :authenticate_user!
  
  def index
    unless user_signed_in?
      redirect_to welcome_url
    end
  end
	
  def welcome
    unless !user_signed_in?
      redirect_to root_url
    end
  end
	
end
