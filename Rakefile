require "rake/testtask"

Rake::TestTask.new do |t|
  t.description = "Run tests"
  t.test_files = FileList["test/*_test.rb"]
  t.libs << "lib"
end

task :default => :test
