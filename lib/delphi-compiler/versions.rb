# encoding: UTF-8

# Delphi compiler wrapper for Ruby.
module Delphi
  # The set of Delphi versions the gem can cope with.
  #
  # This gem only deals with the msbuild versions of Delphi (2010-XE5).
  # Delphi 2009 is left out, because it's project version is
  # the same as Delphi 2010.
  #
  VERSIONS =
  {
    12.0 =>
    {
      name: 'Delphi 2010',
      folder: '7.0',
      project: [12.0],
      version: :D2010
    },
    12.2 =>
    {
      name: 'Delphi XE',
      folder: '8.0',
      project: [12.2, 12.3],
      version: :DXE
    },
    12.3 =>
    {
      name: 'Delphi XE',
      folder: '8.0',
      project: [12.2, 12.3],
      version: :DXE
    },
    13.4 =>
    {
      name: 'Delphi XE2',
      folder: '9.0',
      project: [13.4],
      version: :DXE2
    },
    14.3 =>
    {
      name: 'Delphi XE3',
      folder: '10.0',
      project: [14.3],
      version: :DXE3
    },
    14.6 =>
    {
      name: 'Delphi XE4',
      folder: '11.0',
      project: [14.6],
      version: :DXE4
    }
  }
end
