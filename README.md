delphi-compiler
===============

A ruby gem for compiling Delphi applications.

The rakefile contains a couple of examples to show you how to use the library.

There are three top-level dsl methods:
- delphi
- dunit
- delphi_exe

delphi
------
Usage: 

	delphi :symbol, dproj_file [, platform, configuration] [(, | =>) prerequsites] [block]

The symbol and dproj file are mandatory.

Platform (Win32 | Win64 | etc) and configuration (Debug | Release | etc) are optional, but if you provide one you must provide both.

Prerequsites are optional, and can be preceded by either a comma or a hash pointer (=>) - whatever floats your boat.

The block is optional, and if provided, will be executed after compilation.

dunit
-----
Usage: 

	dunit :symbol, :compile_symbol [(, | =>) prerequsites] [block]

The symbol is mandatory.

The compile symbol is also mandatory, and should be the symbol of the delphi task that compiles the unit tests.

Prerequisites are optional, and again can be separated from the compile symbol by a comma or a hash pointer.

The block is optional and will be executed after the unit tests are run.

delphi_exe
----------
This is a helper method. It takes the symbol of a delphi task as its only argument, and returns the filename of the generated executable.