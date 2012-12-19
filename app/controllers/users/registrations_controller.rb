# encoding: utf-8
class Users::RegistrationsController < Devise::RegistrationsController
  
  def create
    build_resource
    
    if resource.has_correct_name_and_student_number?
      resource.compute_wave
    else
      resource.errors.add(:student_number, "동문 인증에 실패했습니다. 이름과 학번을 다시 확인해주세요")
    end
    
    if resource.errors.empty? && resource.save
      if resource.active_for_authentication?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    password_changed = !params[:user][:password].blank?
   
    successfully_updated = if password_changed
      resource.update_with_password(params[:user])
    else
      resource.update_without_password(params[:user])
    end
       
    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      render "edit"
    end
  end
  
  def verify_alumni
    build_resource
    verified = resource.has_correct_name_and_student_number?
    resource.compute_wave if verified
    
    respond_to do |format|
      format.json { render json: {"name" => resource.name, "wave" => resource.wave, "status" => verified} }
    end
  end
  
end
