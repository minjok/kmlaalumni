# encoding: utf-8
class PostingsController < ApplicationController
  
  
  # *** BEFORE_FILTER *** #
  
  
  # Authenticates that the user is a group member
  before_filter :authenticate_group_member, only: [:create]
  
  # Authenticates that user wrote the posting
  before_filter :authenticate_posting_author, only: [:destroy]
  
  # Verifies that the user doesn't like the posting
  before_filter :verify_user_dislikes_posting, only: [:like]
  
  # Verifies that the user likes the posting
  before_filter :verify_user_likes_posting, only: [:dislike]
  
  
  # *** METHODS *** #
  
  
  # Method: create
  # --------------------------------------------
  # Creates a posting.
  def create
    
    # Creates a new posting instance
    @posting = Posting.new(params[:posting])
    @posting.user = current_user
    if @posting.platform == Posting::PLATFORM['GROUP']
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
  
  # Method: like
  # --------------------------------------------
  # Creates a Like instance for the user and posting.
  def like
    
    # Creates a new like instance
    @like = Like.new
    @like.user = current_user
    @like.posting = @posting
    
    @like.save
    respond_to do |format|
      format.js
    end
    
  end
  
  # Method: dislike
  # --------------------------------------------
  # Destroys the Like instance between the user and posting.
  def dislike
    @like.destroy
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
    @postings = getPostings(params)
    
    # Escapes the case when @postings is nil
    num_pages = @postings.blank? ? 0 : @postings.num_pages
    
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
    # (e.g. Newsfeed, Wall, Group) and calls the corresponding query
    # to fetch a page of paginated postings that match the conditions
    # stated in the params.
    def getPostings(params)
 
      postings = case params[:platform]
        # NEWSFEED
        when 'newsfeed' then 
          Posting.where('group_id IN (?) OR viewability = ?', current_user.groups, Posting::VIEWABILITY['ASSOCIATION']).order('updated_at DESC').page(params[:page]).per(10)
        # WALL
        when 'wall' then
          Posting.where('platform = ?', Posting::PLATFORM['WALL']).order('updated_at DESC').page(params[:page]).per(10)
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
	
    # Method: authenticat_group_member
    # --------------------------------------------
    # BEFORE_FILTER
    # Authenticates that user is a group member
    # ONLY IF the user is writing a posting for a group
    def authenticate_group_member
      
      # Checks that posting for a group and loads group
      if params.has_key?(:posting) && 
         params[:posting].has_key?(:platform) && 
         params[:posting][:platform] == Posting::PLATFORM['GROUP'].to_s

        return unless load_group
        
        # Checks that user is a group member
        unless current_user.is_member_of?(@group)
          flash[:warning] = '그룹의 멤버만 포스팅을 올릴 수 있습니다'
          respond_to do |format|
            format.js { render 'redirect' }
            format.html { redirect_to group_url(@group) }
          end
        end   
           
      end

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
          format.js { render 'redirect' }
          format.html { redirect_to root_url }
        end
      end
    
    end
    
    # Method: verify_user_likes_posting
    # --------------------------------------------
    # BEFORE_FILTER
    # Verifies that the user likes the posting 
    def verify_user_likes_posting
      return unless load_posting
      
      @like = Like.where('user_id = ? AND posting_id = ?', current_user, @posting).first
      unless !@like.blank?
        flash[:warning] = '이미 포스팅을 좋아하지 않습니다'
        respond_to do |format|
          format.js { render 'redirect' }
          format.html { redirect_to root_url }
        end
      end
      
    end
    
    # Method: verify_user_dislikes_posting
    # --------------------------------------------
    # BEFORE_FILTER
    # Verifies that the user doesn't like the posting
    def verify_user_dislikes_posting
      return unless load_posting
      
      if current_user.likes?(@posting)
        flash[:warning] = '이미 포스팅을 좋아합니다'
        respond_to do |format|
          format.js { render 'redirect' }
          format.html { redirect_to root_url }
        end
      end
      
    end
    
end
