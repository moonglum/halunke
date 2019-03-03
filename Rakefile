require "bundler/gem_tasks"
require "rake/testtask"

desc 'Compile Tokenizer and Parser'
task :compile do
  sh 'ragel -R -o lib/halunke/tokenizer.rb lib/halunke/tokenizer.rl'
  sh 'racc -o lib/halunke/parser.rb lib/halunke/grammar.y'
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.deps = [:compile]
end

task default: :test
