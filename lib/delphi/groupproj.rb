# encoding: UTF-8

require 'rexml/document'
require 'delphi/compiler'

module Delphi
  # Class to load and compile dproj files
  #
  # The RW properties of this class can be changed to modify
  # the compilation behaviour of a project, but they will not
  # be saved back to the dproj file - it is read only.
  class GroupProj
    attr_accessor :fail_on_hints_and_warnings

    def initialize(filename)
      @filename = filename
      fail "#{filename} not found" unless File.exist?(filename)

      load
      fail "#{filename} is empty" if projects == []

      # Load one project to initialize the environment
      dproj0 = File.join(File.dirname(filename), projects[0])
      @p = Delphi::Project.new(dproj0)
      @fail_on_hints_and_warnings = true
    end

    # Compile all projects in this group.
    def compile
      puts 'Compiling groupproj'
      compiler.compile_group(@filename, target) if compiler
    end

    # Reader for the compiler setting
    def fail_on_errors
      compiler.fail_on_errors
    end

    # Setter for the compiler setting
    def fail_on_errors=(value)
      compiler.fail_on_errors = value
    end

    # Reader for the compiler setting
    def fail_on_hints_and_warnings
      compiler.fail_on_hints_and_warnings
    end

    # Setter for the compiler setting
    def fail_on_hints_and_warnings=(value)
      compiler.fail_on_hints_and_warnings = value
    end

    # Returns an array of dproj filenames in this group.
    def projects
      path = '/Project/ItemGroup/Projects'
      result = []
      @doc.elements.each(path) { |element| result << element.attributes['Include'] }
      result
    end

    # Read the current compilation target for this group
    def target
      @p.target
    end

    # Set the compilation target for this group
    def target=(value)
      @p.target = value
    end

    # Returns an array of valid compile targets (Clean, Compile, Build)
    def targets
      @p.targets
    end

    private

    def compiler
      @p.compiler
    end

    def load
      File.open(@filename) { |f| @doc = REXML::Document.new f }
    end
  end
end
