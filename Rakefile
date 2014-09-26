require 'bundler'
require 'rake/testtask'
Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/*.rb'
  test.verbose = true
end

task :default => :test
