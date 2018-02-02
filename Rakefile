require "bundler/gem_tasks"
require "rake/testtask"

desc 'Compile Lexer with Ragel'
task :compile do
  sh 'ragel -R -o lib/halunke/lexer.rb lib/halunke/lexer.rl'
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.deps = [:compile]
end

task default: :test
