# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 19) do

  create_table "categories", :force => true do |t|
    t.column "title",  :string
    t.column "parent", :string
    t.column "order",  :integer
  end

  create_table "comments", :force => true do |t|
    t.column "content", :text
    t.column "author",  :integer
    t.column "parent",  :integer
    t.column "time",    :datetime
  end

  create_table "csses", :force => true do |t|
    t.column "name",  :string
    t.column "fname", :string
  end

  create_table "date_for_tnfshes", :force => true do |t|
    t.column "date", :string, :default => "", :null => false
    t.column "note", :text,   :default => "", :null => false
  end

  create_table "diaries", :force => true do |t|
    t.column "title",   :string
    t.column "content", :text
    t.column "date",    :datetime
    t.column "parent",  :string
    t.column "author",  :integer
  end

  create_table "letters", :force => true do |t|
    t.column "title",      :string
    t.column "content",    :text
    t.column "author",     :integer
    t.column "receiver",   :integer
    t.column "created_at", :datetime
    t.column "read",       :boolean
  end

  create_table "menus", :force => true do |t|
    t.column "title",  :string
    t.column "url",    :string
    t.column "parent", :integer
    t.column "order",  :integer
  end

  create_table "permissions", :force => true do |t|
    t.column "title",             :string
    t.column "post",              :boolean
    t.column "edit",              :boolean
    t.column "delete",            :boolean
    t.column "comment",           :boolean
    t.column "god",               :boolean
    t.column "edit_css",          :boolean
    t.column "edit_javascript",   :boolean
    t.column "category_manage",   :boolean
    t.column "user_manage",       :boolean
    t.column "permission_manage", :boolean
    t.column "menu_manage",       :boolean
    t.column "diary_manage",      :boolean
    t.column "mail_manage",       :boolean
    t.column "view_statistics",   :boolean
    t.column "edit_page",         :boolean
    t.column "announce",          :boolean
  end

  create_table "problems", :force => true do |t|
    t.column "probid",       :string
    t.column "title",        :string
    t.column "author",       :string
    t.column "difficulty",   :integer
    t.column "category",     :string
    t.column "modifydate",   :datetime
    t.column "content",      :text
    t.column "hint",         :text
    t.column "solution",     :text
    t.column "article",      :text
    t.column "problem",      :text
    t.column "completeness", :string
    t.column "hit",          :integer,  :default => 0
    t.column "comment",      :integer,  :default => 0
  end

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.column "username",   :string
    t.column "password",   :string
    t.column "regdate",    :datetime
    t.column "permission", :integer
    t.column "css",        :string
  end

end
