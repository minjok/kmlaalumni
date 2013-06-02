#encoding: utf-8
class CareersController < ApplicationController

  def show_organization
    @number = User.count
    @organizations = Organization.order('name')
  end
  # Method: search_organization
  # --------------------------------------------
  #
  def search_organization
    @organization = Organization.find(params[:id])
    @users = @organization.users.order('wave, name').uniq
    respond_to do |format|
      format.js
    end
  end
end
