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

ActiveRecord::Schema.define(:version => 20130424022536) do

  create_table "artists", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "compositions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "names", :force => true do |t|
    t.integer  "artist_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "names", ["name"], :name => "index_names_on_name"

  create_table "performance_artists", :force => true do |t|
    t.integer  "performance_id"
    t.integer  "artist_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "performance_artists", ["artist_id"], :name => "index_performance_artists_on_artist_id"
  add_index "performance_artists", ["performance_id", "artist_id"], :name => "by_performance_artists", :unique => true
  add_index "performance_artists", ["performance_id"], :name => "index_performance_artists_on_performance_id"

  create_table "performance_compositions", :force => true do |t|
    t.integer  "performance_id"
    t.integer  "composition_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "performance_compositions", ["composition_id"], :name => "index_performance_compositions_on_composition_id"
  add_index "performance_compositions", ["performance_id", "composition_id"], :name => "by_performance_compositions", :unique => true
  add_index "performance_compositions", ["performance_id"], :name => "index_performance_compositions_on_performance_id"

  create_table "performances", :force => true do |t|
    t.integer  "youtube_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "performances", ["youtube_id"], :name => "index_performances_on_youtube_id"

  create_table "titles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "composition_id"
  end

  add_index "titles", ["title"], :name => "index_titles_on_title"

  create_table "users", :force => true do |t|
    t.string "google_id"
    t.string "google_name"
    t.string "google_refresh_token"
    t.string "remember_token"
    t.string "google_access_token"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "youtubes", :force => true do |t|
    t.string   "video_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "youtubes", ["video_id"], :name => "index_youtubes_on_video_id", :unique => true

end
