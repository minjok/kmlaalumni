class Like < ActiveRecord::Base
  
  # *** ASSOCIATIONS *** #
  belongs_to :user
  belongs_to :posting
  belongs_to :comment
  
  # *** CONSTANTS *** #
  PLATFORM = {'POSTING' => 1, 'COMMENT' => 2 }
  
  # *** METHODS *** #
  def self.exists?(user_id, platform_id, platform)
    if platform == PLATFORM['POSTING']
      not where("user_id = ? AND posting_id = ?", user_id, platform_id).first.blank?
    elsif platform == PLATFORM['COMMENT']
      not where("user_id = ? AND comment_id = ?", user_id, platform_id).first.blank?
    end
  end
  
end
