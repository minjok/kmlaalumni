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

  # Method: update
  # --------------------------------------------
  # 
  def update
    @user = User.find(current_user.id)
    @update_attr_name = params[:user].keys.first
    @update_attr_value = params[:user][@update_attr_name]
    
    @successfully_updated = if @update_attr_name == 'password'
      @user.update_with_password(params[:user])
    else
      @user.update_without_password(params[:user])
    end
    
    sign_in @user, bypass: true if @successfully_updated
    
    respond_to do |format|
      format.js
    end
  end
  
  # Method: show
  # --------------------------------------------
  # 
  def show
    @user = User.find(params[:id])
  end
  
  # Method: verify_alumni
  # --------------------------------------------
  # 
  def verify_alumni
    @user = User.new
    @user.name = params[:name]
    @user.student_number = params[:student_number]
    @verified = resource.has_correct_name_and_student_number?
    resource.compute_wave if @verified
    
    respond_to do |format|
      format.js
    end
  end
  
end
