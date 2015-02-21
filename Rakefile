require 'rake/testtask'

task :run do
  require_relative 'app'
  set :bind, '0.0.0.0'
  Sinatra::Application.run!
end

Rake::TestTask.new do |t|
  t.pattern = 'tests/*_test.rb'
end

task :default => [:test]
