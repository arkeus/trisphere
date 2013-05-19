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

ActiveRecord::Schema.define(version: 20130519100444) do

  create_table "characters", force: true do |t|
    t.integer "user_id",                                            null: false
    t.boolean "active",                         default: false
    t.string  "name",                limit: 16,                     null: false
    t.integer "energy",                         default: 1000
    t.integer "fatigue",                        default: 1000
    t.integer "strength",                       default: 10
    t.integer "defense",                        default: 10
    t.integer "agility",                        default: 10
    t.integer "wisdom",                         default: 10
    t.string  "mainclass",                      default: "Peasant"
    t.string  "subclass",                       default: "Peasant"
    t.integer "wins",                           default: 0
    t.integer "losses",                         default: 0
    t.integer "draws",                          default: 0
    t.integer "hpc",                            default: 100
    t.integer "hpm",                            default: 100
    t.integer "mpc",                            default: 100
    t.integer "mpm",                            default: 100
    t.integer "combat_level",                   default: 1
    t.integer "combat_xpc",                     default: 0
    t.integer "combat_xpm",                     default: 100
    t.integer "mining_level",                   default: 1
    t.integer "mining_xpc",                     default: 0
    t.integer "mining_xpm",                     default: 100
    t.integer "blacksmithing_level",            default: 1
    t.integer "blacksmithing_xpc",              default: 0
    t.integer "blacksmithing_xpm",              default: 100
    t.integer "woodcutting_level",              default: 1
    t.integer "woodcutting_xpc",                default: 0
    t.integer "woodcutting_xpm",                default: 100
    t.integer "crafting_level",                 default: 1
    t.integer "crafting_xpc",                   default: 0
    t.integer "crafting_xpm",                   default: 100
    t.integer "herbalism_level",                default: 1
    t.integer "herbalism_xpc",                  default: 0
    t.integer "herbalism_xpm",                  default: 100
    t.integer "enchanting_level",               default: 1
    t.integer "enchanting_xpc",                 default: 0
    t.integer "enchanting_xpm",                 default: 100
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

end
