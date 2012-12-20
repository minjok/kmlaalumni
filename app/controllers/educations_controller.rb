class EducationsController < ApplicationController

  def create
    @school = School.where('LOWER(name) = ?', params[:school_name].downcase.strip).first

    if @school.blank?
      @school = School.new(name: params[:school_name].strip)
      @school.save
    end

    @education = @school.valid? ? Education.create(user: current_user, school: @school) : nil
    
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
  end
  
  def update
    @education = Education.find(params[:id])
    @education.update_attributes(params[:education])
    respond_to do |format|
      format.js
    end
  end
  
  def get_school_suggestions
    if params[:term]
      query = params[:term].downcase.strip
      @schools = School.where('LOWER(name) LIKE ?', "#{query}%").limit(5)
    else
      @schools = School.all
    end

    respond_to do |format|  
      format.json { render json: @schools }
    end
  end
  
end
