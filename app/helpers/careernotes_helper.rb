#encoding: utf-8
module CareernotesHelper
  require 'action_view'
  
  def link_to_commentable_modification(commentable)
    if commentable.is_a? Posting
      link_to '삭제', posting_url(commentable), method: :delete, remote: true
    elsif commentable.is_a? Careernote
      link_to '수정', edit_careernote_url(commentable)
    else
      link_to '삭제', '#'
    end
  end
  
  # Method: strip_html(text)
  # --------------------------------------------
  # Removes all html tags from text
  def strip_html(text)
    unless text.nil?
      strip_tags(text)
    end
  end
end
