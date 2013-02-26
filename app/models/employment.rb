class Employment < ActiveRecord::Base
  
  # *** ASSOCIATIONS *** #
  belongs_to :user
  belongs_to :organization
  
  has_one :careernote, dependent: :destroy
    
end
