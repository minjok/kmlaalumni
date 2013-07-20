module TagsHelper
 # *** Get all tags from specific taggable  **#
  def get_tags(type)
    unless type=="all" 
      @tags = Tag.includes(:taggings).where(taggings: {taggable_type: type})
    else
      @tags= Tag.all
    end
  end
  
  # *** Returns true if current_user has tag  **#
  
  def current_user_has_tag
    if Tag.includes(:taggings).where(taggings: {taggable_type: "User", taggable_id: current_user.id})==nil
      false
    end
    return Tag.includes(:taggings).where(taggings: {taggable_type: "User", taggable_id: current_user.id}).map(&:name).include?(@tag.name)
  end
  
end
