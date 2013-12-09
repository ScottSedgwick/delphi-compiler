# encoding: UTF-8

require 'rexml/document'
require 'delphi-compiler/compiler'

module Delphi
  # Class to encapsulate an RC file.
  class Resource
    attr_accessor :haltonfail
    attr_reader :rcfile

    # You need to tell this class what version of Delphi to use, because
    # there is no metadata in an rc file that it can use to determine it.
    def initialize(rcfile, dproj_version, halt_on_fail = true)
      @rcfile = rcfile
      @haltonfail = halt_on_fail
      @compiler = Delphi::Compiler.new(dproj_version)
    end

    def compile
      output = @compiler.compile_rc(@rcfile)
      fail "Error compiling #{@rcfile}:\n#{output}" if @haltOnFail && !$CHILD_STATUS
    end
  end
end
