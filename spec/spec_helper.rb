# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

if ENV['COVERAGE']
  require File.join(File.dirname(File.expand_path(__FILE__)), 'minitest_sequel_coverage')
  SimpleCov.minitest_sequel_coverage
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'rubygems'
require 'sqlite3'
# require 'sequel/paranoid'
require 'minitest/autorun'
require 'minitest/sequel'
require 'minitest/hooks/default'
require 'minitest/assert_errors'
require 'minitest/rg'

DB = Sequel.sqlite # :memory

### ASSOCIATIONS RELATED MODELS
# Author, Category, Comment, Post

DB.create_table(:authors) do
  primary_key :id
  column :name, :text
  column :created_at, :timestamp
  column :updated_at, :timestamp
  column :deleted_at, :timestamp
end

class Author < Sequel::Model
  # used by association tests
end

DB.create_table(:categories) do
  primary_key :id
  column :name, :text
  column :position, :integer, default: 1
  column :created_at, :timestamp
  column :updated_at, :timestamp
end

class Category < Sequel::Model
  # used by association tests
end

DB.create_table(:comments) do
  primary_key :id
  column :post_id, :integer, default: 1
  column :title, :string
  column :body, :text
  column :created_at, :timestamp
  column :updated_at, :timestamp
end

class Comment < Sequel::Model
  # used by association tests
end

DB.create_table(:posts) do
  primary_key :id
  column :category_id, :integer, default: 1
  column :title, 'varchar(255)'
  column :body, :text
  column :author_id, :integer
  column :urlslug, :string
  column :created_at, :timestamp
  column :updated_at, :timestamp
end

class Post < Sequel::Model
  # used by:
  # - association tests
  # - column tests
  #
  # used by #ensure_working_CRUD tests
  def self.make
    create(title: 'Post Title')
  end
end

### /ASSOCIATIONS RELATED MODELS

### COLUMNS RELATED MODELS
# See Post (above)
### /COLUMNS RELATED MODELS

### HELPERS RELATED MODELS
# See Post (above)
### /HELPERS RELATED MODELS

### PLUGINS RELATED MODELS
# :timestamps  Post (with timestamps) & NonTimestampedPost (without timestamps)
DB.create_table(:timestamp_posts) do
  primary_key :id
  column :title, :text
  column :created_at, :timestamp
  column :updated_at, :timestamp
end

class TimestampPost < Sequel::Model
  # used by .plugin(:timestamps) tests

  def self.make
    create(title: 'Post Title')
  end
end

DB.create_table(:created_timestamp_posts) do
  primary_key :id
  column :title, :text
  column :created_at, :timestamp
end

class CreatedTimestampPost < Sequel::Model
  # used by .plugin(:timestamps) tests
end

DB.create_table(:updated_timestamp_posts) do
  primary_key :id
  column :title, :text
  column :updated_at, :timestamp
end

class UpdatedTimestampPost < Sequel::Model
  # used by .plugin(:timestamps) tests
end

DB.create_table(:non_timestamp_posts) do
  primary_key :id
  column :title, :text
end

class NonTimestampPost < Sequel::Model
  # used by .plugin(:timestamps) tests
end

DB.create_table(:ensure_timestamp_posts) do
  primary_key :id
  column :title, :text
  column :created_at, :timestamp
  column :updated_at, :timestamp
end

class EnsureTimestampPost < Sequel::Model
  # used by #ensure_timestamped_model tests
end

# :paranoid  Model (with :deleted_at) & Model (without :deleted_at)
DB.create_table(:paranoid_posts) do
  primary_key :id
  column :title, :text
  column :deleted_at, :timestamp
end

class ParanoidPost < Sequel::Model
  # used by .plugin(:paranoid) tests
  #
  def self.make
    create(title: 'Post Title')
  end
end

DB.create_table(:non_paranoid_posts) do
  primary_key :id
  column :title, :text
  # column :deleted_at, :timestamp
end

class NonParanoidPost < Sequel::Model
  # used by .plugin(:paranoid) tests
end

DB.create_table(:ensure_paranoid_posts) do
  primary_key :id
  column :title, :text
  column :deleted_at, :timestamp
end

class EnsureParanoidPost < Sequel::Model
  # used by .plugin(:paranoid) tests
end

DB.create_table(:crud_paranoid_posts) do
  primary_key :id
  column :title, :text
  column :deleted_at, :timestamp
end

class CrudParanoidPost < Sequel::Model
  # used by .plugin(:paranoid) tests
end

### /PLUGINS RELATED MODELS

### VALIDATIONS RELATED MODELS

DB.create_table(:validation_posts) do
  primary_key :id
  column :category_id, :integer, default: 1
  column :title, 'varchar(255)'
  column :body, :text
  column :author_id, :integer
  column :urlslug, :string
  column :password, :text
  column :created_at, :timestamp
  column :updated_at, :timestamp
end

class ValidationPost < Sequel::Model
  # used by validation tests
end

DB.create_table(:users) do
  primary_key :id
  column :name, :text
  column :email, :text
end

class User < Sequel::Model
  # used by validation tests
end

### /VALIDATIONS RELATED MODELS

####

# rubocop:disable Style/ClassAndModuleChildren
class Minitest::HooksSpec
  around(:all) do |&block|
    DB.transaction(rollback: :always) { super(&block) }
  end

  around do |&block|
    DB.transaction(rollback: :always, savepoint: true, auto_savepoint: true) { super(&block) }
  end

  if defined?(Capybara)
    after do
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
