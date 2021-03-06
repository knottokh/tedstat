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

ActiveRecord::Schema.define(version: 20180523172725) do

  create_table "courses", force: :cascade do |t|
    t.string "couse_code"
    t.string "couse_name"
    t.string "couse_year"
    t.string "couse_detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_courses_on_user_id"
  end

  create_table "emotions", force: :cascade do |t|
    t.string "emotion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
    t.integer "room_id"
    t.integer "user_id"
    t.index ["course_id"], name: "index_emotions_on_course_id"
    t.index ["room_id"], name: "index_emotions_on_room_id"
    t.index ["user_id"], name: "index_emotions_on_user_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "feed_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taskresult_id"
    t.integer "user_id"
    t.integer "task_id"
    t.index ["task_id"], name: "index_feedbacks_on_task_id"
    t.index ["taskresult_id"], name: "index_feedbacks_on_taskresult_id"
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "room_name"
    t.string "room_detail"
    t.string "room_pin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
    t.text "ratio_score"
    t.text "ratio_grade"
    t.integer "point_attr"
    t.index ["course_id"], name: "index_rooms_on_course_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "school_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "education_area"
    t.string "ministry_code"
    t.string "municipal_area"
    t.string "district"
    t.string "province"
    t.string "postcode"
    t.integer "zone"
    t.integer "students_count"
  end

  create_table "scourses", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_id"
    t.integer "user_id"
    t.integer "course_id"
    t.float "average_score", default: 0.0
    t.string "grade"
    t.boolean "is_point_attr", default: false
    t.integer "studenno"
    t.index ["course_id"], name: "index_scourses_on_course_id"
    t.index ["room_id"], name: "index_scourses_on_room_id"
    t.index ["user_id"], name: "index_scourses_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "taskresults", force: :cascade do |t|
    t.string "score"
    t.string "quality"
    t.string "advantage"
    t.string "disadvantage"
    t.text "suggestion"
    t.text "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "task_id"
    t.index ["task_id"], name: "index_taskresults_on_task_id"
    t.index ["user_id"], name: "index_taskresults_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "task_name"
    t.string "task_detail"
    t.string "task_assessment"
    t.string "task_behavior"
    t.text "task_feedback"
    t.datetime "task_duedate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "course_id"
    t.integer "room_id"
    t.float "average_score", default: 0.0
    t.text "task_behavior_extra"
    t.string "task_assignment_other"
    t.datetime "task_alert"
    t.index ["course_id"], name: "index_tasks_on_course_id"
    t.index ["room_id"], name: "index_tasks_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "surname"
    t.string "student_code"
    t.integer "role"
    t.integer "school_id"
    t.string "prefix"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["school_id"], name: "index_users_on_school_id"
  end

end
