# encoding: utf-8

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

desc 'Run RSpec with code coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task[:spec].execute
end

task default: [:spec, :rubocop]
