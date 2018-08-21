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

ActiveRecord::Schema.define(version: 20180821132612) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.string "uid"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "github_users", force: :cascade do |t|
    t.string "avatar_url"
    t.string "email"
    t.integer "gh_id"
    t.string "html_url"
    t.string "login"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login"], name: "index_github_users_on_login"
  end

  create_table "hooks", force: :cascade do |t|
    t.string "hook_type"
    t.integer "gh_id"
    t.string "name"
    t.boolean "active"
    t.string "ping_url"
    t.string "test_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resource_type"
    t.bigint "resource_id"
    t.index ["resource_type", "resource_id"], name: "index_hooks_on_resource_type_and_resource_id"
  end

  create_table "organization_memberships", force: :cascade do |t|
    t.bigint "github_user_id"
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_user_id"], name: "index_organization_memberships_on_github_user_id"
    t.index ["organization_id"], name: "index_organization_memberships_on_organization_id"
  end

  create_table "organization_syncs", force: :cascade do |t|
    t.bigint "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.datetime "start_time"
    t.datetime "end_time"
    t.index ["organization_id"], name: "index_organization_syncs_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.integer "gh_id"
    t.string "login"
    t.string "description"
    t.string "html_url"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "tracked"
  end

  create_table "pull_request_relations", force: :cascade do |t|
    t.bigint "pull_request_id"
    t.bigint "github_user_id"
    t.string "pr_relation_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id"
    t.integer "target_user_id"
    t.datetime "gh_updated_at"
    t.index ["gh_updated_at"], name: "index_pull_request_relations_on_gh_updated_at"
    t.index ["github_user_id"], name: "index_pull_request_relations_on_github_user_id"
    t.index ["organization_id", "gh_updated_at", "github_user_id", "pull_request_id"], name: "index_pr_relations_on_orgs_and_updated_and_user_and_prs"
    t.index ["organization_id", "gh_updated_at", "github_user_id", "target_user_id"], name: "index_pr_relations_on_orgs_and_updated_and_all_users"
    t.index ["organization_id"], name: "index_pull_request_relations_on_organization_id"
    t.index ["pull_request_id"], name: "index_pull_request_relations_on_pull_request_id"
    t.index ["target_user_id"], name: "index_pull_request_relations_on_target_user_id"
  end

  create_table "pull_request_reviews", force: :cascade do |t|
    t.bigint "pull_request_id"
    t.bigint "github_user_id"
    t.integer "gh_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["github_user_id"], name: "index_pull_request_reviews_on_github_user_id"
    t.index ["pull_request_id"], name: "index_pull_request_reviews_on_pull_request_id"
  end

  create_table "pull_requests", force: :cascade do |t|
    t.integer "gh_id"
    t.string "title"
    t.integer "gh_number"
    t.string "pr_state"
    t.string "html_url"
    t.datetime "gh_created_at"
    t.datetime "gh_updated_at"
    t.datetime "gh_closed_at"
    t.datetime "gh_merged_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "repository_id"
    t.integer "owner_id"
    t.integer "merged_by_id"
    t.index ["repository_id"], name: "index_pull_requests_on_repository_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.integer "gh_id"
    t.string "name"
    t.string "full_name"
    t.boolean "tracked", default: false
    t.string "url"
    t.string "html_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organization_id"
    t.datetime "gh_updated_at"
    t.index ["organization_id"], name: "index_repositories_on_organization_id"
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
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "organization_memberships", "github_users"
  add_foreign_key "organization_memberships", "organizations"
  add_foreign_key "organization_syncs", "organizations"
  add_foreign_key "pull_request_relations", "github_users"
  add_foreign_key "pull_request_relations", "pull_requests"
  add_foreign_key "pull_request_reviews", "github_users"
  add_foreign_key "pull_request_reviews", "pull_requests"
  add_foreign_key "pull_requests", "github_users", column: "merged_by_id"
  add_foreign_key "pull_requests", "repositories"
  add_foreign_key "repositories", "organizations"
end
