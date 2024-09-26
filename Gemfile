# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in minitest-have_tag.gemspec
gemspec

# adding these to silence warnings for Ruby v3.5
gem 'fiddle'
gem 'logger'
gem 'ostruct'

group :development do
  # A command line tool to easily handle events on file system modifications
  # DOCS: https://github.com/guard/guard
  gem 'guard'
  # automatically runs your tests with Minitest framework
  # DOCS: https://github.com/guard/guard-minitest
  gem 'guard-minitest'

  # Ruby testing framework
  # DOCS: https://github.com/seattlerb/minitest
  gem 'minitest', '~> 5.7', '>= 5.7.0'
  # Adds specific assertions for testing exceptions with minitest
  # DOCS: https://github.com/kematzy/minitest-assert_errors
  gem 'minitest-assert_errors'
  # Around and before_all/after_all hooks for Minitest
  # DOCS: https://github.com/jeremyevans/minitest-hooks
  gem 'minitest-hooks', '~> 1.1', '>= 1.1.0'
  # Colored red/green output for Minitest
  # DOCS: https://github.com/blowmage/minitest-rg
  gem 'minitest-rg', '~> 5.3', '>= 5.3.0'

  # Ruby build program with capabilities similar to Make
  # DOCS: https://github.com/ruby/rake
  gem 'rake', '~> 13.0'

  # Ruby static code analyzer and formatter
  # DOCS: https://github.com/rubocop/rubocop
  gem 'rubocop', '~> 1.31', require: false
  # Code style checking for Minitest files
  # DOCS: https://github.com/rubocop/rubocop-minitest
  gem 'rubocop-minitest', require: false
  # Performance optimization analysis for your projects
  # DOCS: https://github.com/rubocop/rubocop-performance
  gem 'rubocop-performance', require: false
  # A RuboCop extension focused on enforcing Rake best practices and coding conventions
  # DOCS: https://github.com/rubocop/rubocop-rake
  gem 'rubocop-rake', require: false

  # Code coverage for Ruby
  # DOCS: https://github.com/simplecov-ruby/simplecov
  gem 'simplecov'
end

# Linux-specific gems
install_if -> { RUBY_PLATFORM.include?('linux') } do
  # Linux inotify wrapper for Ruby
  # DOCS: https://github.com/guard/rb-inotify
  gem 'rb-inotify', require: false
end

# macOS-specific gems
install_if -> { RUBY_PLATFORM.include?('darwin') } do
  # FSEvents API with signals handled for macOS
  # DOCS: https://github.com/thibaudgg/rb-fsevent
  gem 'rb-fsevent', require: false
end

# Windows-specific gems
install_if -> { Gem.win_platform? } do
  # Windows Directory Monitor - A library which can be used to monitor directories for changes
  # DOCS: https://github.com/Maher4Ever/wdm
  gem 'wdm'
end
