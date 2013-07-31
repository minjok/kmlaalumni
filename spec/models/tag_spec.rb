require 'spec_helper'

describe Tag do
  describe 'check attribute' do
  
    it 'has a name' do
      FactoryGirl.build(:tag, name:nil).should_not be_valid   
    end
    
    it 'should have a unique name' do
      tag1=FactoryGirl.create(:tag)
      tag2=FactoryGirl.build(:tag)
      tag2.should_not be_valid
    end
    
    it 'should be maximum 15 characters' do
      FactoryGirl.build(:tag, name:"1234567890123456").should_not be_valid
    end
    
  end
  
  describe 'check association' do
    
  end
  
end
