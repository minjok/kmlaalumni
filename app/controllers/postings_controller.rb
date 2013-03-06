# encoding: utf-8
class PostingsController < ApplicationController
  
  
  # *** BEFORE_FILTER *** #
  
  
  # Authenticates that the user is a group member
  before_filter :authenticate_posting_authority, only: [:create]
  
  # Authenticates that user wrote the posting
  before_filter :authenticate_posting_author, only: [:destroy]
  
  # Loads posting with given id
  before_filter :load_posting, only: [:get_content]
  
  # *** METHODS *** #
  
  
  # Method: create
  # --------------------------------------------
  # Creates a posting.
  def create
    
    # Creates a new posting instance
    @posting = Posting.new(params[:posting])
    @posting.user = current_user
    is_public = @posting.platform != Posting::PLATFORM['GROUP']
    if !is_public
      @posting.group = @group
      @posting.viewability = Posting::VIEWABILITY['GROUP']
    end
		
    @posting.save
    respond_to do |format|
      format.js
    end
    
  end
  
  # Method: destroy
  # --------------------------------------------
  # Destroys a posting.
  def destroy
    @posting.destroy
    respond_to do |format|
      format.js
    end
  end
    
  # Method: num_pages
  # --------------------------------------------
  # Returns the number of pages when paginating the
  # postings that match the given conditions stated in the params
  # Pagination is done using the Kaminari gem (https://github.com/amatsuda/kaminari)
  # .num_pages is a function provided by Kaminari.
  # The result is returned in JSON format.
  def num_pages
    
    # Retrieve postings that match the given conditions
    postings = getPostings(params)
    
    # Escapes the case when @postings is nil
    num_pages = postings.blank? ? 0 : postings.num_pages
    
    respond_to do |format|
      format.json { render json: num_pages }
    end
    
  end

  # Method: feed
  # --------------------------------------------
  # Renders the requested page of paginated postings given the
  # conditions stated in the params.
  def feed
  
    # Retrieve postings that match the given conditions
    @postings = getPostings(params)
    @writeability = true
    if params.has_key?(:group_id) && !current_user.is_member_of?(params[:group_id])
      @writeability = false
    end
    
    respond_to do |format|
      format.js
    end
    
  end
  
  # Method: get_content
  # --------------------------------------------
  # Returns the content of a posting
  def get_content
    respond_to do |format|
      format.js
    end
  end
   
  
  # *** PRIVATE METHODS *** #
  
  
  protected
  
    # Method: getPostings
    # --------------------------------------------
    # HELPER METHOD for @num_pages and @feed.
    # Checks the value of params[:platform], which states the
    # type of platform on which the postings are to be rendered
    # (e.g. Newsfeed, Group) and calls the corresponding query
    # to fetch a page of paginated postings that match the conditions
    # stated in the params.
    def getPostings(params)
 
      postings = case params[:platform]
        # ANNOUNCEMENT
        when 'announcement' then
          Posting.where('platform = ?', Posting::PLATFORM['ANNOUNCEMENT']).order('created_at DESC').page(params[:page]).per(10)
        # GROUP
        when 'group' then
          Posting.where('group_id = ?', params[:group_id]).order('updated_at DESC').page(params[:page]).per(10)
        # ESCAPE CASE
        else nil
      end
        
      postings
      
    end
    
    # Method: authenticate_posting_author
    # --------------------------------------------
    # BEFORE_FILTER
    # Authenticates that the user wrote the posting.
    def authenticate_posting_author
      return unless load_posting
      
      unless current_user.wrote?(@posting)
        flash[:warning] = '포스팅을 올린 사람만 삭제할 수 있습니다'
        respond_to do |format|
          format.js { render 'layouts/redirect' }
          format.html { redirect_to root_url }
        end
      end
    
    end
    
end
