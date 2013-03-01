class AddCommentableAttrToComment < ActiveRecord::Migration
  def change
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :string
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type
    Comment.all.each do |comment|
      if !comment.posting_id.blank?
        comment.commentable_id = comment.posting_id
        comment.commentable_type = 'Posting'
      end
      comment.save!
    end
  end
end
