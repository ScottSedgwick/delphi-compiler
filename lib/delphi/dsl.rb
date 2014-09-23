# encoding: UTF-8

require 'rake/clean'
require 'delphi/project'

def _parse_args(args)
  args = (args.take(args.length - 1) + args.last.to_a).flatten if args.last.instance_of?(Hash)
  sym, dproj, platform, config, prereqs = args[0], args[1], nil, nil, []
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
  fail '<Symbol> and <Dproj file> are required arguments to the delphi compilation task' if args.length < 2
  sym, dproj, platform, config, prereqs = _parse_args(args)

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
  Rake::Task[sym].sources = proj

  CLOBBER.include(proj.output)
end

def delphi_exe(sym)
  Rake::Task[sym].sources.output
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
    exe = delphi_exe(compile_sym)
    Dir.chdir(File.dirname(exe)) do
      system(File.basename(exe))
      fail 'Unit tests failed' unless $CHILD_STATUS.to_i == 0
      yield if block_given?
    end
  end
end
