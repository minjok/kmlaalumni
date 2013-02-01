# encoding: utf-8
class Users::RegistrationsController < Devise::RegistrationsController
  
  layout 'welcome', only: [:new, :create]
  
  def new
    super
  end
  
  # Method: create
  # --------------------------------------------
  # 
  def create
    build_resource
    av = AlumniVerification.where('name = ? AND student_number = ?', resource.name, resource.student_number).first
    if av.blank?
      resource.errors.add(:student_number, "동문 인증에 실패했습니다. 이름과 학번을 다시 확인해주세요")
    else
      resource.wave = av.wave
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
  
  # Method: verify_alumni
  # --------------------------------------------
  # 
  def verify_alumni
    @user = User.new
    @user.name = params[:name]
    @user.student_number = params[:student_number]
    av = AlumniVerification.where("name = ? AND student_number = ?", @user.name, @user.student_number).first
    @verified = !av.blank?
    if @verified
      @user.wave = av.wave
    end
    
    respond_to do |format|
      format.js
    end
  end
  
end
