# encoding: utf-8
class PostingsController < ApplicationController
	
	respond_to :html
	
	def create
		
		@posting = Posting.new(params[:posting])
		@posting.group_id = params[:group_id]
		@posting.user_id = current_user.id
		
		if !current_user.is_member_of(@posting.group)
			@posting.errors.add(:membership, "이 그룹의 멤버만 포스팅을 올릴 수 있습니다")
		end
		
		if @posting.save
			respond_with @posting, location: group_url(@posting.group)
		else
			respond_with @posting, action: group_url(@posting.group)
		end
		
	end
	
	def delete
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
        if params.has_key?(:group)
          target_groups =  params[:group]
        else 
          target_groups = current_user.groups
        end
        
        return Posting.where(group_id: target_groups).order('created_at DESC').page(params[:page]).per(10)
      end
	
end
