class Like < ActiveRecord::Base
  
  # *** ASSOCIATIONS *** #
  belongs_to :user
  belongs_to :likeable, polymorphic: true
    
  # *** METHODS *** #
  def self.exists?(user, content)
    not where("user_id = ? AND likeable_id = ?", user, content).first.blank?
  end
  
end
