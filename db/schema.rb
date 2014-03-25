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

ActiveRecord::Schema.define(:version => 20140321034317) do

  create_table "lab_course_students", :force => true do |t|
    t.string   "course_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lab_courses", :force => true do |t|
    t.string   "name"
    t.integer  "categery_id"
    t.integer  "type"
    t.integer  "teacher_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "status"
    t.integer  "report_id"
    t.integer  "progress"
    t.datetime "publish_time"
    t.datetime "apply_time"
    t.string   "approve_time"
    t.integer  "style"
    t.integer  "course_property"
    t.integer  "is_teach"
    t.integer  "before"
    t.integer  "desc"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "lab_coursewares", :force => true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.integer  "productor_id"
    t.integer  "type"
    t.string   "play_time"
    t.string   "file_size"
    t.datetime "product_time"
    t.string   "download_url"
    t.string   "download_times"
    t.datetime "publish_time"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "lab_device_supports", :force => true do |t|
    t.integer  "device_id"
    t.integer  "rel_id"
    t.integer  "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lab_devices", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lab_equipments", :force => true do |t|
    t.string   "name"
    t.string   "equipment_code"
    t.string   "position"
    t.integer  "status"
    t.datetime "install_time"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "lab_eval_projects", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.integer  "categery_id"
    t.integer  "course_type"
    t.integer  "scene_id"
    t.integer  "status"
    t.integer  "supplier_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "lab_permissions", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lab_permissions_roles", :force => true do |t|
    t.integer  "role_id"
    t.integer  "permission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "lab_question_items", :force => true do |t|
    t.string   "desc"
    t.integer  "question_id"
    t.integer  "item_index"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "lab_questions", :force => true do |t|
    t.string   "question"
    t.integer  "report_id"
    t.integer  "report_index"
    t.integer  "answer_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "lab_reports", :force => true do |t|
    t.string   "name"
    t.string   "desc"
    t.integer  "parent_report_id"
    t.integer  "child_report_index"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "lab_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lab_scene_resources", :force => true do |t|
    t.string   "name"
    t.integer  "type"
    t.integer  "play_type"
    t.integer  "play_idle"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lab_scenes", :force => true do |t|
    t.string   "name"
    t.string   "limit"
    t.string   "desc"
    t.integer  "secens_resource_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "lab_seats", :force => true do |t|
    t.integer  "course_id"
    t.integer  "seat_index"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lab_suppliers", :force => true do |t|
    t.string   "name"
    t.string   "tel"
    t.string   "addr"
    t.string   "contacts"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lab_users", :force => true do |t|
    t.string   "name"
    t.string   "mobile"
    t.string   "email"
    t.string   "account"
    t.string   "password"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
