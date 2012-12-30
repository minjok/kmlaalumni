# encoding: utf-8
class Users::SessionsController < Devise::SessionsController

  layout 'welcome', only: [:new]

  def new
    super
  end
  
end
