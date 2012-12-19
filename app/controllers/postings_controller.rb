# encoding: utf-8
class PostingsController < ApplicationController
	
	def create
		@posting = Posting.new(params[:posting])
        @posting.user_id = current_user.id
        if @posting.platform == Posting::PLATFORM['GROUP']
		  @posting.group_id = params[:group_id]
          if !current_user.is_member_of(@posting.group)
            @posting.errors.add(:membership, "이 그룹의 멤버만 포스팅을 올릴 수 있습니다")
          end
        end
		
		@posting.save if @posting.errors.blank?
        
        respond_to do |format|
          format.js
        end
	end
	
	def destroy
      posting = Posting.find(params[:id])
      @posting_id = posting.id
      posting.destroy
      respond_to do |format|
        format.js
      end 
	end
    
    def num_pages
        @postings = getPostings(params)
        respond_to do |format|
          format.json { render json: @postings.num_pages }
        end
    end
    
    def feed
        @postings = getPostings(params)
        respond_to do |format|
          format.js
        end
    end
  
    protected
      def getPostings(params)
        postings = case params[:platform]
          when 'newsfeed' then 
            Posting.where('group_id = ? OR platform = ?', current_user.groups, Posting::PLATFORM['WALL']).order('updated_at DESC').page(params[:page]).per(10)
          when 'wall' then
            Posting.where('platform = ?', Posting::PLATFORM['WALL']).order('updated_at DESC').page(params[:page]).per(10)
          when 'group' then
            Posting.where('group_id = ?', params[:group_id]).order('updated_at DESC').page(params[:page]).per(10)
          else nil
        end
        
        postings
      end
	
end
