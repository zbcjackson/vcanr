# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "standard/rake"

require "cucumber"
require "cucumber/rake/task"

Cucumber::Rake::Task.new(:cucumber)

task default: %i[spec cucumber standard]
