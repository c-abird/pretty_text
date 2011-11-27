require 'rake/testtask'

Rake::TestTask.new do |test|
  test.pattern = 'test/**/*_test.rb'
  test.libs << 'test'
end


begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = "pretty_text"
    gem.summary = "Description of your gem"
    gem.email = "claas@cabird.de"
    gem.authors = ["Claas Abert"]
    gem.files = Dir["{lib}/**/*"]
  end
  Jeweler::GemcutterTasks.new
rescue
  puts "Jeweler or dependency not available."
end
