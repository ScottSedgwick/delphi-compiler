# encoding: UTF-8

require 'singleton'
require 'win32/registry'
require 'delphi/versions'

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
      @configured_version = 0
    end

    # Configure needs to be called on the Environment instance before the
    # Compiler can be used.  Normally it will be done by the Project, which
    # will read the required version of Delphi from the dproj file.
    def configure(project_version)
      return @configured_version if @configured_version == project_version
      @bin_dir = delphi_directory(project_version)
      rsvars = File.join(@bin_dir, 'rsvars.bat')
      load_env(rsvars)
      @configured_version = project_version
    end

    private

    def delphi_directory(delphi_version)
      key = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Embarcadero RAD Studio ' + VERSIONS[delphi_version][:key]
      begin
        Win32::Registry::HKEY_LOCAL_MACHINE.open(key) { |reg| "#{reg['InstallLocation']}\\bin" }
      rescue Win32::Registry::Error
        puts "Delphi Compiler version #{delphi_version} not installed on this computer"
      end
    end

    def load_env(rsvars)
      File.open(rsvars).each { |line| load_line(line[5..-1]) if line =~ /^@SET / }
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
