class EducationController < ApplicationController

  def add
    @school = School.where('LOWER(name) = ?', params[:school_name].downcase.strip).first
    
    if @school.blank?
      @school = School.new(name: params[:school_name].strip)
      @school.save
    end

    Education.request(current_user, @school) if @school.errors.blank?
    
    respond_to do |format|
      format.js
    end
  end
  
  def delete
  end
  
  def update
    @education = Education.find(params[:id])
    @education.update_attributes(params[:education])
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
