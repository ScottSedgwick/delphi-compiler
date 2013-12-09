# encoding: UTF-8

require 'singleton'
require 'delphi-compiler/versions'

module Delphi
  # Environment is a Singleton.
  #
  # It is responsible for initializing the console environment
  # for the verison of Delphi that is requested.
  class Environment
    include Singleton

    # bin_dir is the location of the Delphi executables
    attr_reader :bin_dir

    def initialize
      super
      @env_loaded = false
    end

    # Configure needs to be called on the Environment instance before the
    # Compiler can be used.  Normally it will be done by the Project, which
    # will read the required version of Delphi from the dproj file.
    def configure(project_version)
      unless @env_loaded
        path_version = Delphi::VERSIONS[project_version][:folder]
        rsvars = find_file(delphi_directories(path_version), 'rsvars.bat')
        load_env(rsvars)
        @bin_dir = File.dirname(rsvars)
        @env_loaded = true
      end
    end

    private

    def delphi_directories(version)
      bds = ENV['PATH'].split(/;/).reject do |d|
        !(d =~ /Embarcadero.*#{version}/)
      end
      fail "Delphi #{version} not found" if bds == []
      bds
    end

    def find_file(dirs, filename)
      dirs.each do |d|
        f = File.join(d, filename)
        return f if File.exists?(f)
      end
      fail "#{filename} not found in any of the following folders: " +
           "[#{dirs.join(';')}]"
    end

    def load_env(rsvars)
      File.open(rsvars) do |f|
        until f.eof?
          line = f.gets
          load_line(line[5..-1]) if line =~ /^@SET /
        end
      end
    end

    def load_line(line)
      key, value = line.split(/\=/)
      ENV[key] = process_env_var(value)
    end

    def map_path(path)
      path.split(';').map { |p| yield(p).chomp }.join(';')
    end

    def process_env_var(value)
      map_path(value) { |v| substitute(v.chomp) }
    end

    def substitute(value)
      value =~ /^%(.*)%$/ ? ENV[value[1..-2]] : value
    end
  end
end
