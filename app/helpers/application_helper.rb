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
   
end
