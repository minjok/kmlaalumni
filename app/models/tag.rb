class Tag < ActiveRecord::Base
  
  # *** ATTRIBUTES *** #
  attr_accessible :name, :tag_tokens
  attr_reader :tag_tokens
  # *** VALIDATIONS *** #
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 15
  
  
  # *** ASSOCIATIONS *** #
  has_many :taggings, dependent: :destroy
  has_many :taggables, through: :taggings
  has_many :taggers,  through: :taggings
  
  def tag_tokens=(ids)
    self.tag_ids = ids.split(",")
  end
end
