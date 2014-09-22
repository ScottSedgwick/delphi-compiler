# encoding: UTF-8

$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')

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
task :build_prereq1 do
  puts 'Build prerequisite 1'
end

task :build_prereq2 do
  puts 'Build prerequisite 2'
end

task :build_prereq3 do
  puts 'Build prerequisite 3'
end

desc 'Compile test project'
delphi :testd, 'C:\dev\delphi-compiler\test\test.dproj', 'Win32', 'Debug' => :build_prereq1 do |p|
  puts "Finished building #{p.output}"
end
task testd: :build_prereq2

desc 'Compile unit tests'
delphi :unitd, 'C:\dev\delphi-compiler\test\Test\testTests.dproj' => :build_prereq1 do |p|
  puts "Finished building #{p.output}"
end

dunit :unit_tests, unitd: :build_prereq2 do
  puts 'Finished Unit Testing'
end
task unit_tests: :build_prereq3
