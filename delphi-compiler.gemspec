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
    'rakefile.rb',
    'version.rb',
    'lib/delphi.rb',
    'lib/delphi/compiler.rb',
    'lib/delphi/dsl.rb',
    'lib/delphi/environment.rb',
    'lib/delphi/groupproj.rb',
    'lib/delphi/project.rb',
    'lib/delphi/resource.rb',
    'lib/delphi/versions.rb',
    'test/MyClass.pas',
    'test/test.dproj',
    'test/test.dpr',
    'test/test.res',
    'test/test_project.rb',
    'test/TestGroup.groupproj',
    'test/Test/TestMyClass.pas',
    'test/Test/testTests.dpr',
    'test/Test/testTests.dproj',
    'test/Test/testTests.res'
  ]
  s.homepage    = 'http://rubygems.org/gems/delphi-compiler'
  s.license     = 'MIT'
end
