class Membership < ActiveRecord::Base
	
  #	*** ASSOCIATIONS ***	#
  belongs_to :user
  belongs_to :group
	
	
  #	*** METHODS ***	#
  def self.exists?(user, group)
    not where("user_id = ? AND group_id = ?", user, group).first.blank?
  end
	
  def self.exists_as_admin?(user, group)
    not where("user_id = ? AND group_id = ? AND admin = ?", user, group, true).first.blank?
  end
	
  def self.other_members_exist?(user, group)
    not where("user_id != ? AND group_id = ?", user, group).first.blank?
  end
	
  def self.other_admins_exist?(user, group)
    not where("user_id != ? AND group_id = ? AND admin = ?", user, group, true).first.blank?
  end
	
  def self.request(user, group, admin)
    unless Membership.exists?(user, group)
      create!(user: user, group: group, admin: admin)
    end
  end
	
  def self.breakup(user, group)
    membership = where("user_id = ? AND group_id = ?", user, group).first
    unless membership.blank?
      destroy(membership)
    end
  end
	
end
