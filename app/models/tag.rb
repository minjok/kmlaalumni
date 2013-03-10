class Tag < ActiveRecord::Base
  
  # *** ATTRIBUTES *** #
  attr_accessible :name
  
  # *** ASSOCIATIONS *** #
  has_many :taggings, dependent: :destroy
  has_many :taggables, through: :taggings
  has_many :taggers,  through: :taggings
  
end
