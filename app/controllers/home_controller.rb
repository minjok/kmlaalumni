class HomeController < ApplicationController
  
  layout 'welcome', only: [:welcome]
  
  # *** BEFORE_FILTER *** #
  
  
  # User authentication is not required for @index and @welcome
  skip_before_filter :authenticate_user!
  
  
  # *** PUBLIC METHODS *** #
  
  
  # Method: index
  # --------------------------------------------
  # Root page of the applicaton.
  def index
  
    # Checks if user is signed in and redirects to @welcome if not.
    unless user_signed_in?
      redirect_to welcome_url
    end
  end
  
  # Method: welcome
  # --------------------------------------------
  # Renders the landing page when not signed in.	
  
  def welcome
    
    # Checks if user is not signed in and redirects to @index if not.
    unless !user_signed_in?
      redirect_to root_url
    end
    
  end
	
end
