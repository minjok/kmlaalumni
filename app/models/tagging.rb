class Tagging < ActiveRecord::Base
  # *** ASSOCIATIONS *** #
  belongs_to :taggable
  belongs_to :tagger
end
