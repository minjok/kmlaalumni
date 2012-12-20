class Education < ActiveRecord::Base

	#	*** ASSOCIATIONS ***	#
	belongs_to :user
	belongs_to :school
	
end
