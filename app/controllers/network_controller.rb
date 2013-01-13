class NetworkController < ApplicationController
  
  def search
  
    @users = nil
    name = params[:name].strip
    wave = params[:wave]
    school = params[:school].strip
    organization = params[:organization].strip
    
    if !name.empty? && !wave.empty?
      @users = User.where('name = ? AND wave = ?', name, wave).order('wave, name') 
    elsif !name.empty?
      @users = User.where('name = ?', name).order('wave, name')   
    elsif !wave.empty?
      @users = User.where('wave = ?', wave).order('wave, name')
    end

    if !school.empty?
      school = School.where('name = ? ', school).first
      school_users = school.users.order('wave, name').uniq
      if @users.nil?
        @users = school_users
      else
        @users = @users & school_users
      end
    end
    
    if !organization.empty?
      organization = Organization.where('name = ? ', organization).first
      organization_users = organization.users.order('wave, name').uniq
      if @users.nil?
        @users = organization_users
      else
        @users = @users & organization_users
      end
    end 
    
    if @users.nil?
      @users = User.order('wave, name')
    end
    
    respond_to do |format|
      format.js
    end
      
  end
  
end
