class CustomAuthenticationFailure < Devise::FailureApp 
  protected 
    def redirect_url 
      welcome_url
    end 
end 
