# encoding: utf-8
class SettingsController < ApplicationController


  # *** BEFORE_FILTER *** #
  
  
  # Verify that the params format and values are correct
  before_filter :verify_correct_params, only: [:get_form]
  
  
  # *** PUBLIC METHODS *** #
  
  
  # Method: get_form
  # --------------------------------------------
  # Renders the requested update form section.
  def get_form
    @section = params[:section]
    @form_container_id = params[:section]
    @form_container_id += '_' + params[:id] if params[:id]
    @form_container_id += '_container'
  end
  
  
  # *** PRIVATE METHODS *** #
  
  
  protected
  
  
    # Method: verify_correct_params
    # --------------------------------------------
    # BEFORE_FILTER
    # Verifies the format and values of params passed for @get_form
    #
    # (1) Checks that params has :section
    # (2) IF params[:section] is a type that requires no id -> TRUE
    # (3) OTHERWISE Checks that params has :id
    # (4) IF params[:section] is 'update_education_'form and
    #     an Education instance with :id exists -> TRUE
    # (5) IF params[:section[is 'update_employment_'form and
    #     an Employment instance with :id exists -> TRUE
    # (6) OTHERWISE -> FALSE
    def verify_correct_params
      
      has_correct_params = false
      
      # Section types that do not require id
      no_require_section_types = ['update_email_form',
                                  'update_password_form',
                                  'add_education_form',
                                  'add_employment_form',]
                      
      # Checks that params has :section
      if params.has_key?(:section)
        
        # Checks if the :section value is in no_require_section_types
        if no_require_section_types.include?(params[:section])
          has_correct_params = true  
        else
          
          # Checks if params has :id
          if params.has_key?(:id)
          
            if params[:section] == 'update_education_form'
              # Checks if Education instance with given :id exists
              @education = Education.find_by_id(params[:id])
              has_correct_params = true if !@education.blank?
              
            elsif params[:section] == 'update_employment_form'
              # Checks if Employment instance with given :id exists
              @employment = Employment.find_by_id(params[:id])
              has_correct_params = true if !@employment.blank?
            end
            
          end
        end
      end
      
      unless has_correct_params
        flash[:warning] = '잘못된 접근이 시도 되었습니다'
        respond_to do |format|
          format.js { render 'redirect' }
          format.html { redirect_to root_url }
        end
      end
     
    end
end
