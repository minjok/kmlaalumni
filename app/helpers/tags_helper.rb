module TagsHelper
 # *** Get all tags from specific taggable  **#
  def get_tags(type)
    @tags = Tag.includes(:taggings).where(taggings: {taggable_type: type})
  end
end
