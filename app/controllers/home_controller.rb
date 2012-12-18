class HomeController < ApplicationController
  
  skip_before_filter :authenticate_user!, only: :welcome
  
  def index
  end
	
  def welcome
    unless !user_signed_in?
      redirect_to root_url
    end
  end
	
end
