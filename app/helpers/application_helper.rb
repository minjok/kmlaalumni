#encoding: utf-8
module ApplicationHelper
  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def simple_format(text)
    text = '' if text.nil?
    text = text.dup
    text = sanitize(text)
    text = text.to_str
    text.gsub!(/\r\n/, "<br>")
    text.html_safe
  end
 
  def link_to_delete_commentable(commentable)
    if commentable.is_a? Posting
      link_to '삭제', posting_url(commentable), method: :delete, remote: true
    elsif commentable.is_a? Careernote
      link_to '삭제', destroy_careernote_url(commentable.employment), remote: true
    else
      '삭제'
    end
  end
  
end
