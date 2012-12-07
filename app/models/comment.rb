#encoding: utf-8
class Comment < ActiveRecord::Base

  #	*** ASSOCIATIONS *** #
  belongs_to :user
  belongs_to :posting
  
  
  # *** VALIDATIONS *** #
  validates_presence_of :content,
                           message: "빈 댓글을 올리실 수 없습니다"
  
end
