class NetworkController < ApplicationController
  
  def school
    @schools = School.order('name')
  end
  
  def organization
    @organizations = Organization.order('name')
  end
  
  def get_everyone
    @users = User.order('wave, name')
    
    respond_to do |format|
      format.js { render 'search_alumni' }
    end
  end
  
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
  
  def search_school
    @school = School.find(params[:id])
    @users = @school.users
    respond_to do |format|
      format.js
    end
  end
  
  def search_organization
    @organization = Organization.find(params[:id])
    @users = @organization.users
    respond_to do |format|
      format.js
    end
  end
  
end
