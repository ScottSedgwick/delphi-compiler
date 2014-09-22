# encoding: UTF-8

require 'rake/clean'
require 'delphi/project'

def _load_args(args)
  result = args
  fail '<Symbol> and <Dproj file> are required arguments to the delphi compilation task' if result.length < 2

  if result.last.instance_of?(Hash)
    last_idx = result.length - 1
    p = result[last_idx][result[last_idx].keys[0]]
    result[last_idx] = result[last_idx].keys[0]
    result << p
  end
  result
end

def _parse_args(args)
  sym      = args[0]
  dproj    = args[1]
  platform = nil
  config   = nil
  prereqs  = []
  case args.length
  when 5
    platform = args[2]
    config   = args[3]
    prereqs  = args[4]
  when 4
    platform = args[2]
    config   = args[3]
  when 3
    prereqs  = args[2]
  end
  [sym, dproj, platform, config, prereqs]
end

def delphi(*args)
  sym, dproj, platform, config, prereqs = _parse_args(_load_args(args))

  proj = Delphi::Project.new(dproj)
  proj.platform = platform if platform
  proj.config = config if config
  task sym => prereqs do
    Rake::Task[proj.output].invoke
  end
  file proj.output do
    proj.compile
    yield proj if block_given?
  end
  Rake::Task[sym].sources = dproj

  CLEAN.include(proj.output)
end

def dunit(sym, prereqs)
  if prereqs.instance_of?(Hash)
    compile_sym = prereqs.keys[0]
    prereqs = prereqs[compile_sym]
  else
    compile_sym = prereqs
    prereqs = []
  end
  prereqs = [prereqs, compile_sym].flatten
  task sym => prereqs do
    exe = Delphi::Project.new(Rake::Task[compile_sym].sources).output
    Dir.chdir(File.dirname(exe)) do
      system(File.basename(exe))
      fail 'Unit tests failed' unless $CHILD_STATUS.to_i == 0
      yield if block_given?
    end
  end
end
