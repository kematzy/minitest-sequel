# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rake/testtask'

RuboCop::RakeTask.new

Rake::TestTask.new(:spec) do |t|
  t.libs << 'spec'
  t.libs << 'lib'
  t.options = '--rg'
  t.test_files = FileList['spec/**/*_spec.rb']
end

task default: %i[rubocop coverage]

desc 'alias for spec task'
task test: :spec

desc 'Run specs with coverage'
task :coverage do
  ENV['COVERAGE'] = '1'
  Rake::Task['spec'].invoke
end
