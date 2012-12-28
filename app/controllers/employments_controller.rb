class EmploymentsController < ApplicationController

  # Method: create
  # --------------------------------------------
  # 
  def create
    @organization = Organization.where('LOWER(name) = ?', params[:organization_name].downcase.strip).first

    if @organization.blank?
      @organization = Organization.new(name: params[:organization_name].strip)
      @organization.save
    end

    @employment = @organization.errors.blank? ? Employment.create(user: current_user, organization: @organization) : nil
    
    respond_to do |format|
      format.js
    end
  end
  
  # Method: destroy
  # --------------------------------------------
  # 
  def destroy
  end
  
  # Method: update
  # --------------------------------------------
  #
  def update
    @employment = Employment.find(params[:id])
    @employment.update_attributes(params[:employment])
    respond_to do |format|
      format.js
    end
  end
  
  # Method: get_organization_suggestions
  # --------------------------------------------
  #
  def get_organization_suggestions
    if params[:term]
      query = params[:term].downcase.strip
      @organizations = Organization.where('LOWER(name) LIKE ?', "%#{query}%").limit(5)
    else
      @organizations = Organization.limit(5)
    end

    respond_to do |format|  
      format.json { render json: @organizations }
    end
  end
end
