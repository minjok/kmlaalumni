require 'spec_helper'

describe Careernote do
  
  it 'has a content' do
    FactoryGirl.build(:careernote, content:nil).should_not be_valid   
  end
  
end
