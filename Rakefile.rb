# encoding: UTF-8

require 'rake/testtask'
require 'delphi'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc 'Run tests'
task default: :test

desc 'Build the gem'
task :build do
  system('gem build delphi-compiler.gemspec')
end

desc 'Install the gem'
task :install do
  require_relative 'version'
  system("gem install ./delphi-compiler-#{VERSION}.gem")
end

######################################################################################
# Example tasks to exercise the delphi library.
namespace :example do
  task :prereq1 do
    puts 'Build prerequisite 1'
  end

  task :prereq2 do
    puts 'Build prerequisite 2'
  end

  task :prereq3 do
    puts 'Build prerequisite 3'
  end

  desc 'Compile test project'
  delphi :delphiproj, 'C:\dev\delphi-compiler\test\test.dproj', 'Win32', 'Debug' => 'example:prereq1' do |p|
    puts "Finished building #{p.output}"
  end
  task delphiproj: 'example:prereq2'

  desc 'Compile unit tests'
  delphi :testproj, 'C:\dev\delphi-compiler\test\Test\testTests.dproj' => 'example:prereq1' do |p|
    puts "Finished building #{p.output}"
  end

  desc 'Run unit tests'
  dunit :unit_tests, 'example:testproj' => 'example:prereq2' do
    puts 'Finished Unit Testing'
  end
  task unit_tests: 'example:prereq3'
end
