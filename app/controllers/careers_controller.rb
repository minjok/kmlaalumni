class CareersController < ApplicationController
 
  def new_note
    @careernote = Careernote.new
  end
  
  def create_note
    @careernote = Careernote.new(params[:careernote])
    if @careernote.save
      redirect_to careers_url
    else
      render 'new_note'
    end
  end
  
  def feed_notes
   @careernotes = Careernote.order('create_at DESC')
  end
    
end
