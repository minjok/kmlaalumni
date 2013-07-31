# encoding: utf-8

require 'faker'

FactoryGirl.define do 
  factory :user do |f| 
    #To get unique email
    sequence(:email) { |n| "user#{n}@example.com" }
    
    f.name "박지호"
    f.wave 12
    f.student_number "072096"
    f.password "abcdefg"
  end 
end
