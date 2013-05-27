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

ActiveRecord::Schema.define(version: 20130526020123) do

  create_table "characters", force: true do |t|
    t.integer  "user_id",                                            null: false
    t.boolean  "active",                         default: false
    t.string   "name",                limit: 16,                     null: false
    t.integer  "energy",                         default: 1000
    t.integer  "fatigue",                        default: 1000
    t.integer  "strength",                       default: 10
    t.integer  "wisdom",                         default: 10
    t.integer  "defense",                        default: 10
    t.integer  "agility",                        default: 10
    t.integer  "stamina",                        default: 10
    t.integer  "spirit",                         default: 10
    t.string   "surclass",                       default: "Peasant"
    t.string   "subclass",                       default: "Peasant"
    t.integer  "wins",                           default: 0
    t.integer  "losses",                         default: 0
    t.integer  "draws",                          default: 0
    t.integer  "hpc",                            default: 100
    t.integer  "hpm",                            default: 100
    t.integer  "mpc",                            default: 100
    t.integer  "mpm",                            default: 100
    t.integer  "combat_level",                   default: 1
    t.integer  "combat_xpc",                     default: 0
    t.integer  "combat_xpm",                     default: 100
    t.integer  "mining_level",                   default: 1
    t.integer  "mining_xpc",                     default: 0
    t.integer  "mining_xpm",                     default: 100
    t.integer  "blacksmithing_level",            default: 1
    t.integer  "blacksmithing_xpc",              default: 0
    t.integer  "blacksmithing_xpm",              default: 100
    t.integer  "woodcutting_level",              default: 1
    t.integer  "woodcutting_xpc",                default: 0
    t.integer  "woodcutting_xpm",                default: 100
    t.integer  "crafting_level",                 default: 1
    t.integer  "crafting_xpc",                   default: 0
    t.integer  "crafting_xpm",                   default: 100
    t.integer  "herbalism_level",                default: 1
    t.integer  "herbalism_xpc",                  default: 0
    t.integer  "herbalism_xpm",                  default: 100
    t.integer  "enchanting_level",               default: 1
    t.integer  "enchanting_xpc",                 default: 0
    t.integer  "enchanting_xpm",                 default: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characters", ["user_id", "active"], name: "index_characters_on_user_id_and_active"

  create_table "forum_categories", force: true do |t|
    t.string   "name",                     null: false
    t.string   "description",              null: false
    t.integer  "topics",       default: 0
    t.integer  "replies",      default: 0
    t.integer  "last_post_id", default: 0
    t.integer  "order",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_posts", force: true do |t|
    t.integer  "post_type",                                    null: false
    t.integer  "category_id",                                  null: false
    t.integer  "topic_id"
    t.integer  "user_id"
    t.string   "subject",           limit: 64
    t.text     "raw_message",                                  null: false
    t.text     "message",                                      null: false
    t.datetime "post_date",                                    null: false
    t.datetime "touch_date",                                   null: false
    t.datetime "edit_date"
    t.integer  "replies",                      default: 0
    t.integer  "views",                        default: 0
    t.integer  "last_view_ip",      limit: 8
    t.integer  "last_post_user_id"
    t.boolean  "sticky",                       default: false
    t.boolean  "locked",                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forum_posts", ["category_id", "post_type"], name: "index_forum_posts_on_category_id_and_post_type"
  add_index "forum_posts", ["category_id", "topic_id"], name: "index_forum_posts_on_category_id_and_topic_id"

  create_table "items", force: true do |t|
    t.integer  "character_id"
    t.integer  "base_id"
    t.integer  "prefix_id"
    t.integer  "suffix_id"
    t.integer  "enchant_id"
    t.boolean  "equipped",     default: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",        limit: 16,               null: false
    t.string   "password_digest",                          null: false
    t.string   "email",           limit: 64,               null: false
    t.integer  "ip",              limit: 8
    t.integer  "gold",                       default: 500
    t.integer  "shards",                     default: 0
    t.integer  "posts",                      default: 0
    t.string   "avatar"
    t.string   "signature"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], name: "index_users_on_username"

end
