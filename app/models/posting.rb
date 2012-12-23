# encoding: utf-8
class Posting < ActiveRecord::Base
	
	# *** ASSOCIATIONS *** # 
	belongs_to :user
	belongs_to :group
    
    has_many :comments, dependent: :destroy
    has_many :likes,    dependent: :destroy
    
	# *** CONSTANTS *** #
    PLATFORM = {'WALL' => 1, 'GROUP' => 2 }
    
	# *** VALIDATIONS *** #
	validates_presence_of :content, 
							message: '빈 포스팅을 올리실 수 없습니다'
    
    validates_presence_of :platform,
                            message: '글 올리는 도중 에러가 발생했습니다'
    
    validates_inclusion_of :platform, in: PLATFORM.values,
                            message: '글 올리는 도중 에러가 발생했습니다 w'
end
