require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'bundler/gem_tasks'

# SimpleCov for test coverage
begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
  puts "SimpleCov not available. Install it with: gem install simplecov"
end

# Default task: run unit tests
desc 'Default: run unit tests.'
task default: :test

# Test task: run all unit tests in the test directory
desc 'Test the base58 library.'
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/test_*.rb'
  t.verbose = false
end

# RDoc task: generate documentation
desc 'Generate RDoc documentation.'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'base58'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.md', 'lib/**/*.rb')
end

# Build task: create a gem using bundler
desc 'Build the gem package'
task :build do
  sh 'gem build base58.gemspec'
end

# Install task: install the gem locally
desc 'Install the gem locally'
task :install => :build do
  sh 'gem install ./base58-*.gem'
end

# Release task: tag the release and push to rubygems
desc 'Release the gem to RubyGems'
task :release => [:build] do
  sh 'git tag -a v#{version} -m "Version #{version}"'
  sh 'git push --tags'
  sh 'gem push base58-*.gem'
end
