# encoding: utf-8
class Organization < ActiveRecord::Base
  
  # *** ASSOCIATIONS *** #
  has_many :users, through: :employments
  has_many :careernotes, through: :employments
  has_many :employments, dependent: :destroy

  # *** VALIDATIONS *** #
  validates_presence_of :name,
                          message: "직장/단체 이름을 입력하세요"
                          
  def has_no_members?
    Employment.where("organization_id = ?", self).first.blank?
  end
  
end
