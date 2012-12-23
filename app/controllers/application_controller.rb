class ApplicationController < ActionController::Base
  protect_from_forgery 
  
  # Authenticates whether user is logged in for every request
  before_filter :authenticate_user!
  
end
