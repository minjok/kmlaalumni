class Like < ActiveRecord::Base
  
  # *** ASSOCIATIONS *** #
  belongs_to :user
  belongs_to :posting
  belongs_to :comment
    
  # *** METHODS *** #
  def self.exists_for_posting?(user, posting)
    not where("user_id = ? AND posting_id = ?", user, posting).first.blank?
  end
  
  def self.exists_for_comment?(user, comment)
    not where("user_id = ? AND comment_id = ?", user, comment).first.blank?
  end
  
end
