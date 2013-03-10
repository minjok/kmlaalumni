# encoding: utf-8
class Careernote < ActiveRecord::Base
  
  # *** ASSOCIATIONS *** #
  belongs_to :employment
  
  has_one :user, through: :employment
  has_one :organization, through: :employment
  
  has_many :activities, as: :feedable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, as: :taggable, through: :taggings
   
  # *** VALIDATIONS *** #
  validates_presence_of :content,
                          message: '빈 소개글을 올릴 수 없습니다'
                          
end
