# encoding: utf-8
class PostingsController < ApplicationController
  
  # Method: create
  # --------------------------------------------
  # Creates a posting.
  def create
    
    # Creates a posting instance
    @posting = Posting.new(params[:posting])
    @posting.user_id = current_user.id
    
    # Association and validation if posting is posted on a group
    if @posting.platform == Posting::PLATFORM['GROUP']
      @posting.group_id = params[:group_id]
     
      # Validates if the user is a group member
      unless current_user.is_member_of(@posting.group)
        @posting.errors.add(:membership, "이 그룹의 멤버만 포스팅을 올릴 수 있습니다")
      end
    end
		
    @posting.save if @posting.errors.blank?
        
    respond_to do |format|
      format.js
    end
    
  end
  
  # Method: destroy
  # --------------------------------------------
  # Destroys a posting.
  def destroy
  
    # Retrieves the posting with given id
    @posting = Posting.find(params[:id])
    
    # Necessary attribute for JS rendering after posting destruction
    @posting_id = @posting.id.to_s
    @destroyed = false
    
    # Validates that the user wrote the posting
    unless current_user.wrote?(@posting)
      @posting.errors.add(:ownership, '이 포스팅을 삭제할 권한이 없습니다')
    end
    
    # Destroys posting if posting is successfully validated
    if @posting.errors.blank?
      @posting.destroy
      @destroyed = true
    end
    
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
  
  def like
    
    @like = Like.new
    @like.user = current_user
    
    @posting = Posting.find(params[:id])
    if @posting.blank?
      @like.errors.add(:posting, '해당 포스팅이 존재하지 않습니다')
    else
      @like.posting = @posting
      if Like.exists_for_posting?(current_user, @posting)
        @like.errors.add(:posting, '이미 포스팅을 좋아합니다')
      end
    end
    
    @like.save if @like.errors.blank?
    
    respond_to do |format|
      format.js
    end
    
  end
  
  def dislike

    @destroyed = false
    @posting = Posting.find(params[:id])
    if @posting.blank?
      # TO-DO: FLASH MESSAGE FOR NO SUCH POSTING
    else
      @like = Like.where('user_id = ? AND posting_id = ?', current_user, @posting).first
      if @like.blank?
        # TO-DO: FLASH MESSAGE FOR NO SUCH LIKE
      else
        @like.destroy
        @destroyed = true
      end
    end
    
    respond_to do |format|
      format.js
    end
    
  end
  
  protected
  
    # Method: getPostings
    # --------------------------------------------
    # Helper method for @num_pages and @feed.
    # Checks the value of params[:platform], which states the
    # type of platform on which the postings are to be rendered
    # (e.g. Newsfeed, Wall, Group) and calls the corresponding query
    # to fetch a page of paginated postings that match the conditions
    # stated in the params.
    def getPostings(params)
 
      postings = case params[:platform]
        # NEWSFEED
        when 'newsfeed' then 
          Posting.where('group_id = ? OR platform = ?', current_user.groups, Posting::PLATFORM['WALL']).order('updated_at DESC').page(params[:page]).per(10)
        # WALL
        when 'wall' then
          Posting.where('platform = ?', Posting::PLATFORM['WALL']).order('updated_at DESC').page(params[:page]).per(10)
        # GROUP
        when 'group' then
          Posting.where('group_id = ?', params[:group_id]).order('updated_at DESC').page(params[:page]).per(10)
        # ESCAPE CASE
        else nil
      end
        
      postings
      
    end
	
end
