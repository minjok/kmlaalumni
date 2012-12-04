class School < ActiveRecord::Base
	
	#	*** ASSOCIATIONS ***	#
	has_many :users,	through: :educations
	has_many :educations, 	dependent: :destroy
	
end
