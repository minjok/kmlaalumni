class Tagging < ActiveRecord::Base
  # *** ASSOCIATIONS *** #
  belongs_to :taggable, :polymorphic =>true
  belongs_to :tagger, :polymorphic =>true
  belongs_to :tags
 end
 
