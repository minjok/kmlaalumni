# encoding: utf-8
class School < ActiveRecord::Base
	
	#	*** ASSOCIATIONS ***	#
	has_many :users,	through: :educations
	has_many :educations, 	dependent: :destroy

    # *** VALIDATIONS *** #
    validates_presence_of :name,
                          message: "학교 이름을 입력하세요"
end
