ENV["RACK_ENV"] = "test"
if ENV["COVERAGE"]
  require File.join(File.dirname(File.expand_path(__FILE__)), "minitest_sequel_coverage")
  SimpleCov.minitest_sequel_coverage
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "rubygems"
require "sqlite3"
# require "sequel/paranoid"
require "minitest/autorun"
require "minitest/sequel"
require "minitest/assert_errors"
# require "minitest/rg"
# require "minitest/color"
# require "minitest/documentation"

DB = Sequel.sqlite # :memory

DB.create_table(:posts) do
  primary_key  :id
  column :category_id,  :integer, default: 1
  column :title,        "varchar(255)"
  column :body,         :text
  column :author_id,    :integer
  column :urlslug,      :string

  column :created_at,   :timestamp
  column :updated_at,   :timestamp
end

DB.create_table(:created_posts) do
  primary_key  :id
  column :category_id,  :integer, default: 1
  column :title,        "varchar(255)"
  column :body,         :text
  column :author_id,    :integer
  column :urlslug,      :string

  # column :created_at,   :timestamp
  column :updated_at,   :timestamp
end

DB.create_table(:updated_posts) do
  primary_key  :id
  column :category_id,  :integer, default: 1
  column :title,        "varchar(255)"
  column :body,         :text
  column :author_id,    :integer
  column :urlslug,      :string

  column :created_at,   :timestamp
  # column :updated_at,   :timestamp
end

DB.create_table(:paranoid_posts) do
  primary_key :id
  column :category_id,  :integer, default: 1
  column :title,        "varchar(255)"
  column :body,         :text
  column :author_id,    :integer
  column :urlslug,      :string

  # column :deleted_at,   :timestamp
end


DB.create_table(:categories) do
  primary_key  :id
  column :name,         :text
  column :position,     :integer, default: 1

  column :created_at,   :timestamp
  column :updated_at,   :timestamp
end

DB.create_table(:comments) do
  primary_key  :id
  column :post_id,      :integer, default: 1
  column :title,        :string
  column :body,         :text

  column :created_at,   :timestamp
  column :updated_at,   :timestamp
end

DB.create_table(:authors) do
  primary_key  :id
  column :name,         :text

  column :created_at,   :timestamp
  column :updated_at,   :timestamp
  column :deleted_at,   :timestamp
end

DB.create_table(:dummies) do
  primary_key  :id
  column :title, :text
  column :password, :text
end

####

class Post < Sequel::Model;

  # used by #ensure_working_CRUD tests
  def self.make
    create(title: "Post Title")
  end

end
class CreatedPost < Sequel::Model; end
class UpdatedPost < Sequel::Model; end
class ParanoidPost < Sequel::Model; end

class Comment < Sequel::Model; end

class Author < Sequel::Model; end

class Category < Sequel::Model; end

class Dummy < Sequel::Model; end
