#encoding: utf-8
class CareersController < ApplicationController

  def show_organization
    @organizations = Organization.order('name')
  end
    
end
