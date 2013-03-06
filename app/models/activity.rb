class Activity < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :feedable, polymorphic: true # The source of the activity ex. Posting
  belongs_to :venue, polymorphic: true  # Where the activity occurs ex. Group
  
  def self.created_feedable(feedable)
    activity = Activity.new
    activity.feedable = feedable
    activity.user = feedable.user    
    activity.created_at = feedable.created_at
    activity.updated_at = feedable.updated_at
    if feedable.class.name == 'Posting' && feedable.viewability == Posting::VIEWABILITY['GROUP']
      activity.is_public = false
      activity.venue = feedable.group
    end
    activity.save!
  end

end
