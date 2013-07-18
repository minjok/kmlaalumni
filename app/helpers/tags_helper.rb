module TagsHelper
 # *** Get all tags from specific taggable  **#
  def get_tags(type)
    unless type=="all" 
      @tags = Tag.includes(:taggings).where(taggings: {taggable_type: type})
    else
      @tags= Tag.all
    end
  end
end
