module HomeHelper
  
  # get_progress_percentage 
  # return percentage of current_user's profile&careernote update
  # 25% - completion of signup
  # 50% - filling in basic info
  # 75% - filling in school&employment info
  # 100% - writing careernote 
  def get_progress_percentage
    if current_user.sex.blank? || current_user.birthday.blank?
      return 25
    elsif current_user.employments.blank? && current_user.educations.blank?
      return 50
    elsif current_user.careernotes.blank? && !(current_user.employments.blank?)
      return 75
    else
      return 100
    end
  end
end
