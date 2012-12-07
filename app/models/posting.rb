# encoding: utf-8
class Posting < ActiveRecord::Base
	
	# *** ASSOCIATIONS *** # 
	belongs_to :user
	belongs_to :group
    
    has_many :comments, dependent: :destroy
    
	
	# *** VALIDATIONS *** #
	validates_presence_of :content, 
							message: "빈 포스팅을 올리실 수 없습니다"
end
