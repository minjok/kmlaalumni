class Tag < ActiveRecord::Base
  
  # *** ATTRIBUTES *** #
  attr_accessible :name
  
  # *** VALIDATIONS *** #
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 15
  
  
  # *** ASSOCIATIONS *** #
  has_many :taggings, dependent: :destroy
  has_many :taggables, through: :taggings
  has_many :taggers,  through: :taggings
end
