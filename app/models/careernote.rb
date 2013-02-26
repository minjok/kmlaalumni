class Careernote < ActiveRecord::Base
  
  # *** ASSOCIATIONS *** #
  belongs_to :employment
  
  has_one :user, through: :employment
  
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

end
