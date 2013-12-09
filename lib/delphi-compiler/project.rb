# encoding: UTF-8

require 'rexml/document'
require 'delphi-compiler/compiler'

module Delphi
  # Class to load and compile dproj files
  #
  # The RW properties of this class can be changed to modify
  # the compilation behaviour of a project, but they will not
  # be saved back to the dproj file - it is read only.
  class Project
    # The configuration to build - think Debug, Release.
    attr_accessor :config
    # The platform to build for - think Win32, Win64.
    attr_accessor :platform
    # The msbuild target - Build, Compile, Clean.
    attr_accessor :target
    # A reader for the compiler instance.
    attr_reader :compiler
    attr_reader :filename
    # The file that should be generated by compilation.
    attr_reader :output

    def initialize(filename)
      @filename = filename
      fail "#{filename} not found" unless File.exists?(filename)

      load
      @compiler = Delphi::Compiler.new(project_version)
      @config = default_config
      @target = targets[0]
      @platform = platforms[0]
      outputpath = '/Project/PropertyGroup/DCC_DependencyCheckOutputName'
      @output = File.expand_path(File.join(File.dirname(@filename),
                                           get(outputpath).text))
    end

    def compile
      @compiler.compile(@filename, @target, @config, @platform)
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

    # Set the platform. Restricts it to valid values.
    def platform=(value)
      check_value(platforms, value, 'platform')
      @platform = value
    end

    # Returns the set of valid platforms as read from the dproj file
    #
    # TODO : This might be wrong. Test it more carefully.
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
    #
    # TODO : This is hard coded. Should it be read from the dproj?
    def targets
      %w(Build Compile Clean)
    end

    private

    def check_value(collection, value, name)
      fail "#{value} is not a valid #{name} for #{@filename}" unless
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
      File.open(@filename) { |f| @doc = REXML::Document.new f }
    end
  end
end