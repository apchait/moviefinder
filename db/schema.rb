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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140306003222) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "locations", force: true do |t|
    t.string   "description"
    t.string   "formatted_address"
    t.decimal  "lat"
    t.decimal  "lng"
    t.decimal  "ne_lat"
    t.decimal  "ne_lng"
    t.decimal  "sw_lat"
    t.decimal  "sw_lng"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "fun_facts"
  end

  create_table "movies", force: true do |t|
    t.string   "title"
    t.string   "downcase_title"
    t.string   "release_year"
    t.string   "production_company"
    t.string   "distributor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rt_id"
    t.string   "mpaa_rating"
    t.integer  "critics_score"
    t.integer  "audience_score"
    t.text     "synopsis"
    t.string   "poster_url"
    t.string   "clip_url"
    t.string   "clip_thumb_url"
  end

  create_table "movies_personalities", force: true do |t|
    t.integer "movie_id"
    t.integer "personality_id"
    t.integer "actor_id"
    t.integer "director_id"
    t.integer "writer_id"
  end

  create_table "personalities", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
