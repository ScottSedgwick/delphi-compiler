# encoding: UTF-8

require 'test/unit'
require 'delphi-compiler/project'

# Test case for Delphi::Project class
class ProjectTest < Test::Unit::TestCase
  def setup
    filename = File.join(File.dirname(__FILE__), 'test.dproj')
    @project = Delphi::Project.new(filename)
  end

  def test_version
    assert_equal(14.6, @project.project_version)
  end

  def test_configs
    expected = %w('Debug', 'Release_US', 'Release_Versioned', 'Profile',
                  'Release')
    configs = @project.configs
    assert_equal(expected.size, configs.size)
  end

  def test_default_config
    assert_equal('Release_Versioned', @project.config)
  end

  def test_default_platform
    assert_equal('Win32', @project.platform)
  end

  def test_output
    expected = File.join(File.dirname(@project.filename), 'CustomSound.exe')
    assert_equal(expected, @project.output)
  end
end
