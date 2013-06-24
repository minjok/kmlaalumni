# encoding: utf-8
class TagsController < ApplicationController
 
  def add_tag_button
    @tag = Tag.new
    respond_to do |format|
      format.js
    end
  end
  
  def add_tag
    respond_to do |format|
      format.js
    end
  end
end
