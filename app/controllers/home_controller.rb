class HomeController < ApplicationController
  
  skip_before_filter :authenticate_user!, only: :welcome
  
  def index
  end
	
  def welcome
  end
	
end
