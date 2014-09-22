# encoding: UTF-8

require 'test/unit'
require 'delphi'

# Test case for Delphi::Project class
class ProjectTest < Test::Unit::TestCase
  def setup
    filename = File.join(File.dirname(__FILE__), 'test.dproj')
    @project = Delphi::Project.new(filename)
  end

  def test_version
    assert_equal(16.0, @project.project_version)
  end

  def test_configs
    expected = %w(Debug Release)
    configs = @project.configs
    assert_equal(expected.size, configs.size)
    expected.each { |c| assert(configs.include?(c.to_s), "#{c} not found in configs #{configs}") }
  end

  def test_default_config
    assert_equal('Debug', @project.config)
  end

  def test_default_platform
    assert_equal('Win32', @project.platform)
  end

  def test_platforms
    expected = %w(Win32)
    platforms = @project.platforms
    assert_equal(expected.size, platforms.size)
    expected.each { |p| assert(platforms.include?(p.to_s), "#{p} not found in platforms #{platforms}") }
  end

  def test_output
    dir = File.dirname(@project.dproj)
    exe = File.basename(@project.dproj, '.dproj') + '.exe'
    expected = File.join(dir, @project.platform, @project.config, exe)
    assert_equal(expected, @project.output)
  end
end
