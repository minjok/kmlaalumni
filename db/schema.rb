# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130627143040) do

  create_table "activities", :force => true do |t|
    t.integer  "feedable_id"
    t.string   "feedable_type"
    t.integer  "venue_id"
    t.string   "venue_type"
    t.boolean  "is_public",     :default => true, :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "user_id"
  end

  add_index "activities", ["feedable_id"], :name => "index_activities_on_feedable_id"
  add_index "activities", ["feedable_type"], :name => "index_activities_on_feedable_type"
  add_index "activities", ["venue_id"], :name => "index_activities_on_venue_id"
  add_index "activities", ["venue_type"], :name => "index_activities_on_venue_type"

  create_table "alumni_verifications", :force => true do |t|
    t.string  "name",           :null => false
    t.string  "student_number", :null => false
    t.integer "wave",           :null => false
  end

  create_table "careernotes", :force => true do |t|
    t.text     "content",       :null => false
    t.integer  "employment_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "content",          :null => false
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"

  create_table "educations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.string   "major"
    t.string   "degree"
    t.date     "entrance_year"
    t.date     "graduation_year"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "employments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "position"
    t.date     "start_year"
    t.date     "end_year"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "groups", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "likeable_id"
    t.string   "likeable_type"
  end

  add_index "likes", ["likeable_id"], :name => "index_likes_on_likeable_id"
  add_index "likes", ["likeable_type"], :name => "index_likes_on_likeable_type"

  create_table "memberships", :force => true do |t|
    t.boolean "admin",    :default => false, :null => false
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "organizations", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "postings", :force => true do |t|
    t.text     "content",                    :null => false
    t.integer  "platform",                   :null => false
    t.integer  "viewability", :default => 1, :null => false
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "schools", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                      :null => false
    t.integer  "wave",                                      :null => false
    t.string   "student_number",                            :null => false
    t.string   "phone_number"
    t.string   "address"
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "is_admin",               :default => false
    t.string   "fb"
    t.string   "tw"
    t.string   "ln"
    t.string   "blog"
    t.datetime "birthday"
    t.string   "sex"
    t.string   "profile_picture"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
