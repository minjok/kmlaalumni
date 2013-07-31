# encoding: utf-8
require 'spec_helper'

describe User do
  it 'has a valid factory' do
    FactoryGirl.create(:user).should be_valid
  end
  
  describe 'check attributes' do
    
    context 'check presence' do
      
      it 'has a name' do
	FactoryGirl.build(:user, name:nil).should_not be_valid
      end
  
      it 'has a wave' do
	FactoryGirl.build(:user, wave:nil).should_not be_valid
      end
      
      it 'has a email' do
	FactoryGirl.build(:user, email:nil).should_not be_valid
      end
      
      it 'has a password' do
	FactoryGirl.build(:user, password:nil).should_not be_valid
      end
      
    end
    
    context 'check format' do
      
      it 'has a right number of wave' do
	FactoryGirl.build(:user, wave:202).should_not be_valid
      end
      
      it 'has a proper format of email' do
	user=FactoryGirl.build(:user, email:"abcde")
	user.should_not be_valid
	user.should have(1).error_on(:email)
	user=FactoryGirl.build(:user, email:"@gmail.com")
	user.should_not be_valid
	user.should have(1).error_on(:email)   
      end
      
      it 'has a password of minimum length of 6' do
	FactoryGirl.build(:user, password:"12345").should_not be_valid
      end
      
      it 'has a password of maximum length of 20' do
	FactoryGirl.build(:user, password:"123456789012345678901").should_not be_valid
      end
      
      it 'has a proper format of fb url' do
	user=FactoryGirl.build(:user, fb:"https://")
	user.should_not be_valid
	user.should have(1).error_on(:fb)
	user=FactoryGirl.build(:user, fb:"abdefg")
	user.should_not be_valid
	user.should have(1).error_on(:fb)   
      end
      
      
      it 'has a proper format of tw url' do
	user=FactoryGirl.build(:user, tw:"https://")
	user.should_not be_valid
	user.should have(1).error_on(:tw)
	user=FactoryGirl.build(:user, tw:"abdefg")
	user.should_not be_valid
	user.should have(1).error_on(:tw)   
      end
      
      it 'has a proper format of ln url' do
	user=FactoryGirl.build(:user, ln:"https://")
	user.should_not be_valid
	user.should have(1).error_on(:ln)
	user=FactoryGirl.build(:user, ln:"abdefg")
	user.should_not be_valid
	user.should have(1).error_on(:ln)   
      end
      
      it 'has a proper format of blog url' do
	user=FactoryGirl.build(:user, blog:"https://")
	user.should_not be_valid
	user.should have(1).error_on(:blog)
	user=FactoryGirl.build(:user, blog:"abdefg")
	user.should_not be_valid
	user.should have(1).error_on(:blog)   
      end
      
      it 'has a proper format of sex'  do
	user=FactoryGirl.build(:user, sex:"h")
	user.should_not be_valid
	user.should have(1).error_on(:sex)
      end
      
    end
    
    context 'check uniquness' do
      
      it 'has a unique student number' do
	user1 = FactoryGirl.create(:user)
	user2 = FactoryGirl.build(:user)
	user2.should_not be_valid
	user2.should have(1).error_on(:student_number)
      end	    
      
       it 'has a unique email' do                 
	user1 = FactoryGirl.create(:user, email:"user@gmail.com")
	user2 = FactoryGirl.build(:user, email:"user@gmail.com")
	user2.should_not be_valid
	user2.should have(1).error_on(:email)
      end
      
      
    end
    
  end
  
  
  
  
  
  
  
  
 
  
  
  
  
  

  
end
