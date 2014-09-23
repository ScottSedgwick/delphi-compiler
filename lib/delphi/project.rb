# encoding: UTF-8

require 'rexml/document'
require 'delphi/compiler'

module Delphi
  # Class to load and compile dproj files
  #
  # The RW properties of this class can be changed to modify
  # the compilation behaviour of a project, but they will not
  # be saved back to the dproj file - it is read only.
  class Project
    # The configuration to build - e.g. Debug, Release.
    attr_accessor :config
    # The platform to build for - e.g. Win32, Win64.
    attr_accessor :platform
    # The msbuild target - e.g. Build, Compile, Clean.
    attr_accessor :target

    attr_reader :dproj

    def initialize(dproj)
      @dproj = dproj
      fail "#{dproj} not found" unless File.exist?(dproj)

      load
      @compiler = Delphi::Compiler.new(project_version)
      @config = default_config
      @target = targets[0]
      @platform = platforms[0]
      @outputpath = get('//DCC_ExeOutput').text
    end

    def compile
      @compiler.compile(@dproj, @target, @config, @platform)
    end

    # Set the config. Restricts it to valid values.
    def config=(value)
      check_value(configs, value, 'config')
      @config = value
    end

    def fail_on_hints_and_warnings
      @compiler.fail_on_hints_and_warnings
    end

    def fail_on_hints_and_warnings=(value)
      @compiler.fail_on_hints_and_warnings = value
    end

    # Returns the set of valid configurations as read from the dproj file
    def configs
      result = []
      @doc.elements.each('/Project/ItemGroup/BuildConfiguration') do |element|
        config = element.attributes['Include']
        result << config unless config == 'Base'
      end
      result
    end

    # The output file without the path.
    def out_file
      File.basename(@output)
    end

    def output
      File.expand_path(File.join(subst_path(@outputpath), File.basename(@dproj, '.dproj') + '.exe'))
    end

    # Set the platform. Restricts it to valid values.
    def platform=(value)
      check_value(platforms, value, 'platform')
      @platform = value
    end

    # Returns the set of valid platforms as read from the dproj file
    def platforms
      path = '/Project/PropertyGroup/Platform'
      result = []
      @doc.elements.each(path) { |element| result << element.text }
      result
    end

    def project_version
      path = 'Project/PropertyGroup/ProjectVersion'
      @project_version = get(path).text.to_f unless @project_version
      @project_version
    end

    # Set the target. Restricts it to valid values.
    def target=(value)
      check_value(targets, value, 'target')
      @target = value
    end

    # Returns the set of valid targets
    def targets
      %w(Build Compile Clean)
    end

    private

    def check_value(collection, value, name)
      fail "#{value} is not a valid #{name} for #{@dproj}" unless
        collection.include?(value)
    end

    def default_config
      dc = get('Project/PropertyGroup/Configuration')
      dc ? dc.text : 'Debug'
    end

    def get(path)
      REXML::XPath.first(@doc, path)
    end

    def load
      File.open(@dproj) { |f| @doc = REXML::Document.new f }
    end

    def subst_path(path)
      result = path.sub('$(Platform)', platform).sub('$(Config)', config)
      result = File.join(File.dirname(dproj), result) if result.start_with?('.')
      File.expand_path(result)
    end
  end
end
