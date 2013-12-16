# encoding: UTF-8

require 'delphi-compiler/environment'

module Delphi
  # Class to execute Delphi compiler
  #
  # You should not need to directly interact with this class.
  # It is accessed via the compile methods of the Project,
  # GroupProj and Resource classes
  class Compiler
    attr_accessor :fail_on_hints_and_warnings, :fail_on_errors

    # You need to pass the Delphi target version to this class.
    # If you use the Project or GroupProj classes, they will figure
    # this out for you from the information in the dproj file.
    def initialize(project_version, fail_on_hints_and_warnings = true)
      Delphi::Environment.instance.configure(project_version)
      @fail_on_hints_and_warnings = fail_on_hints_and_warnings
      @fail_on_errors = true
    end

    # Compile a Project (dproj file)
    def compile(dproj, target, config, platform)
      puts "Compiling #{dproj}"
      cmd = sprintf(FMT_COMPILE, target, config, platform, dproj)
      compile_output = `#{cmd}`
      check_for_failure(compile_output)
    end

    # Compile a Project Group (groupproj file)
    def compile_group(groupproj, target)
      puts "Compiling #{groupproj}"
      Dir.chdir(File.dirname(groupproj)) do
        cmd = sprintf(FMT_COMPILE_GROUP, target, File.basename(groupproj))
        compile_output = `#{cmd}`
        check_for_failure(compile_output)
      end
    end

    # Compile a Resource (rc file)
    def compile_rc(rcfile)
      puts "Compiling #{rcfile}"
      Dir.chdir(File.dirname(rcfile)) do
        cmd = sprintf(FMT_COMPILE_RC, File.basename(rcfile))
        `#{cmd}`
      end
    end

    def bds
      File.join(Delphi::Environment.instance.bin_dir, 'bds.exe')
    end

    private

    FMT_COMPILE = 'msbuild.exe /nologo /t:%s /p:Config=%s;Platform=%s "%s"'
    FMT_COMPILE_GROUP = 'msbuild.exe /v:q /nologo /t:%s "%s"'
    FMT_COMPILE_RC = 'brcc32.exe "%s"'

    def check_for_failure(output)
      if @fail_on_errors && found_errors?(output) 
        puts output
        fail "Compilation failed. Errors found."
      end
      if fail_due_to_hints_or_warnings?(output)
        puts output
        fail "Compilation failed. Hints and Warnings found."
      end
      output
    end

    def fail_due_to_hints_or_warnings?(output)
      @fail_on_hints_and_warnings && found_hints_or_warnings?(output)
    end

    def found_hints?(output)
      output =~ / Hint:/
    end

    def found_hints_or_warnings?(output)
      found_hints?(output) || found_warnings?(output)
    end

    def found_warnings?(output)
      !(output =~ / 0 Warning\(s\)/)
    end

    def found_errors?(output)
      !(output =~ / 0 Error\(s\)/)
    end
  end
end
