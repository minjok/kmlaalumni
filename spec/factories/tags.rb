# encoding: utf-8

require 'faker'

FactoryGirl.define do 
  factory :tag do |f| 
    sequence(:id) { |n| n }
    f.name "tag"
  end
  
  factory :tagging do |f|
    f.association :tag
    f.association :taggable
  end
  
  factory :careernote, class: :careernote, parent:taggable do |f|
          
  end
  
end



