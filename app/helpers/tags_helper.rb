module TagsHelper

  
  # *** Returns true if current_user has tag  **#
  
  def current_user_has_tag
    if Tag.includes(:taggings).where(taggings: {taggable_type: "User", taggable_id: current_user.id})==nil
      false
    end
    return Tag.includes(:taggings).where(taggings: {taggable_type: "User", taggable_id: current_user.id}).map(&:name).include?(@tag.name)
  end
  
  # *** Returns a hash of tagging info  **#
  
  def find_tagging_information(tagging)
    taggable = tagging.taggable_type.constantize.find(tagging.taggable_id)
    tagger = User.find(tagging.tagger_id)
    tag = Tag.find(tagging.tag_id)
    return {:tag => tag, :taggable => taggable, :tagger => tagger}
  end
  
end
