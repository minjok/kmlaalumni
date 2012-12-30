# encoding: utf-8
class Users::SessionsController < Devise::SessionsController

  layout 'welcome', only: [:new, :create]

  def new
    super
  end
  
  def create
    super
  end
  
end
