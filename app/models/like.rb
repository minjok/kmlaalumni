class Like < ActiveRecord::Base
  
  # *** ASSOCIATIONS *** #
  belongs_to :user
  belongs_to :posting
  belongs_to :comment
  belongs_to :careernote
    
  # *** METHODS *** #
  def self.exists_for_content?(user, content, type)
    not where("user_id = ? AND #{type}_id = ?", user, content).first.blank?
  end
  
end
