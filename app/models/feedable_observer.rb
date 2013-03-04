class FeedableObserver < ActiveRecord::Observer
  observe :posting, :careernote
  
  def after_create(feedable)
    Activity.created_feedable(feedable)
  end
  
end
