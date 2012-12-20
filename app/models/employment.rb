class Employment < ActiveRecord::Base
  
  # *** ASSOCIATIONS *** #
  belongs_to :user
  belongs_to :organization
    
end
