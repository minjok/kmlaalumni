class AddLikeableAttrToLike < ActiveRecord::Migration
  def change
    add_column :likes, :likeable_id, :integer
    add_column :likes, :likeable_type, :string
    add_index :likes, :likeable_id
    add_index :likes, :likeable_type
    Like.all.each do |like|
      if !like.posting_id.blank?
        like.likeable_id = like.posting_id
        like.likeable_type = 'Posting'
      elsif !like.comment_id.blank?
        like.likeable_id = like.comment_id
        like.likeable_type = 'Comment'
      end
      like.save!
    end
  end
end
 
