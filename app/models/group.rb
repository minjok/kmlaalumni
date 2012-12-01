#encoding: utf-8
class Group < ActiveRecord::Base
	
	#	*** ASSOCIATIONS ***	# 
	has_many :users,		through: :memberships
	has_many :memberships,	dependent: :destroy
	
	
	#	*** VALIDATIONS ***	#
	validates_presence_of 	:name,
								message: "소모임 이름을 입력해주세요"
	
	validates_uniqueness_of :name, case_sensitive: false,
								message: "이미 같은 이름을 사용하는 소모임이 있습니다"
	
	validates_length_of 	:description, within: 1..200, allow_blank: true,
								message: "소모임 설명은 200자내로 입력해주세요"
						
						
	# *** METHODS *** #
	def has_other_members_than?(user)
		Membership.other_members_exist?(user, self)
	end
	
	def has_other_admins_than?(user)
		unless Membership.other_admins_exist?(user, self)
			self.errors.add(:membership, "소모임을 나가시기 전에 소모임의 새로운 관리자를 선임하셔야 합니다")
			false
		end	
		true
	end
							
end