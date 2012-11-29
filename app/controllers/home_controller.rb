class HomeController < ApplicationController
	
	def index
		if !user_signed_in?
			redirect_to :welcome
		end
	end
	
	def welcome
	end
end
