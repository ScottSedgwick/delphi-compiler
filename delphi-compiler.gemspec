require './version'

Gem::Specification.new do |s|
  s.name        = 'delphi-compiler'
  s.version     = VERSION
  s.date        = '2013-12-04'
  s.summary     = 'Delphi Compiler'
  s.description = 'A framework to compile Delphi applications from Rake'
  s.authors     = ['Scott Sedgwick']
  s.email       = 'scott.sedgwick@gmail.com'
  s.files       = [
    'delphi-compiler.gemspec',
    'Rakefile.rb',
    'version.rb',
    'lib/delphi-compiler.rb',
    'lib/delphi-compiler/compiler.rb',
    'lib/delphi-compiler/environment.rb',
    'lib/delphi-compiler/groupproj.rb',
    'lib/delphi-compiler/project.rb',
    'lib/delphi-compiler/resource.rb',
    'lib/delphi-compiler/versions.rb',
    'test/test.dproj',
    'test/test_project.rb'
  ]
  s.homepage    = 'http://rubygems.org/gems/delphi-compiler'
  s.license     = 'MIT'
end
