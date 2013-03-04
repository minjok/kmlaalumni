class Activity < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :feedable, polymorphic: true
  
  def self.created_feedable(feedable)
    activity = Activity.new
    activity.feedable = feedable
    activity.user = feedable.user    
    activity.created_at = feedable.created_at
    activity.updated_at = feedable.updated_at
    activity.is_public = feedable.class.name != 'Posting' || feedable.viewability != Posting::VIEWABILITY['GROUP']
    activity.save!
  end

end
