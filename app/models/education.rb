class Education < ActiveRecord::Base

	#	*** ASSOCIATIONS ***	#
	belongs_to :user
	belongs_to :school
	
	#	*** METHODS ***	#
	def self.exists?(user, school)
		not where("user_id = ? AND school_id = ?", user, school).first.blank?
	end
	
	def self.request(user, school)
		unless Education.exists?(user, school)
			create!(user: user, school: school)
		end
	end
	
	def self.breakup(user, school)
		education = where("user_id = ? AND school_id = ?", user, school).first
		unless education.blank?
			destroy(education)
		end
	end
	
end
