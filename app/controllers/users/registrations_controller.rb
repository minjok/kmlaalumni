# encoding: utf-8
class Users::RegistrationsController < Devise::RegistrationsController
	
  def create
    build_resource
    
    if resource.has_correct_name_and_student_number?
      resource.compute_wave
    else
      resource.errors.add(:student_number, "동문 확인에 실패했습니다. 이름과 학번을 다시 확인해주세요")
    end
    
    if resource.errors.empty? && resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
	
end
