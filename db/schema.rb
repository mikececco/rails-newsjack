# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_28_191729) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_analytics_views_per_days", force: :cascade do |t|
    t.string "site", null: false
    t.string "page", null: false
    t.date "date", null: false
    t.bigint "total", default: 1, null: false
    t.string "referrer_host"
    t.string "referrer_path"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["date"], name: "index_active_analytics_views_per_days_on_date"
    t.index ["referrer_host", "referrer_path", "date"], name: "index_active_analytics_views_per_days_on_referrer_and_date"
    t.index ["site", "page", "date"], name: "index_active_analytics_views_per_days_on_site_and_date"
  end

  create_table "generate_posts", force: :cascade do |t|
    t.string "trend"
    t.string "company_website_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mail_lists", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "content"
    t.string "slug"
    t.index ["slug"], name: "index_resources_on_slug", unique: true
  end

  create_table "scrapers", force: :cascade do |t|
    t.string "country_code"
    t.string "country_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "scraped_news"
  end

  create_table "search_preferences", force: :cascade do |t|
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trial_click_users", force: :cascade do |t|
    t.text "company_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "waiting_users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firstname"
    t.text "company_name"
  end

end
