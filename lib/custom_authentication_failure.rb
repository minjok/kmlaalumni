class CustomAuthenticationFailure < Devise::FailureApp 
  def redirect_url 
    welcome_url
  end 
    
  def respond
    if http_auth?
      http_auth
    else
      flash[:warning] = i18n_message unless flash[:notice]
      redirect_to login_url
    end
  end
end 
