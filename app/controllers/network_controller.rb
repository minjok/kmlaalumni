class NetworkController < ApplicationController
  
  # Method: profile
  # --------------------------------------------
  # 
  def profile
    @user = User.find(params[:id])
  end
  
  # Method: school
  # --------------------------------------------
  # 
  def school
    @schools = School.order('name')
  end
  
  # Method: organization
  # --------------------------------------------
  # 
  def organization
    @organizations = Organization.order('name')
  end
  
  # Method: search_alumni
  # --------------------------------------------
  # 
  def search_alumni
  
    @users = nil
    name = params[:name].strip
    wave = params[:wave]
    
    if !name.empty? && !wave.empty?
      @users = User.where('name = ? AND wave = ?', name, wave).order('wave, name') 
    elsif !name.empty?
      @users = User.where('name = ?', name).order('wave, name')   
    elsif !wave.empty?
      @users = User.where('wave = ?', wave).order('wave, name')
    end
    
    if @users.nil?
      @users = User.order('wave, name')
    end
    
    respond_to do |format|
      format.js
    end
      
  end
  
  # Method: search_school
  # --------------------------------------------
  # 
  def search_school
    @school = School.find(params[:id])
    @users = @school.users.order('wave, name')
    respond_to do |format|
      format.js
    end
  end
  
  # Method: search_organization
  # --------------------------------------------
  # 
  def search_organization
    @organization = Organization.find(params[:id])
    @users = @organization.users.order('wave, name')
    respond_to do |format|
      format.js
    end
  end
  
end
