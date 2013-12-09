# encoding: UTF-8

require 'rake/testtask'

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

desc 'Compile Custom Sound (local)'
task :csl do
  lib = File.join(File.dirname(__FILE__), 'lib')
  puts lib
  $LOAD_PATH.unshift(lib)
  require 'delphi-compiler'
  cs = Delphi::Project.new('c:/dev/customsound/source/CustomSound.dproj')
  cs.compile
end

desc 'Compile Custom Sound (gem)'
task :csg do
  require 'delphi-compiler'
  cs = Delphi::Project.new('c:/dev/customsound/source/CustomSound.dproj')
  cs.compile
end
