(*
    Unit       : fb_sys
    Date       : 2022-01-03
    Compiler   : Delphi XE3, Delphi 12
    ©Copyright : Shalamyansky Mikhail Arkadievich
    Contents   : Firebird UDR OS wrapper functions plugin module
    Project    : https://github.com/shalamyansky/fb_sys
    Company    : BWR
*)
library fb_sys;

uses
    fbsys_register in 'fbsys_register.pas'
;
{$R *.res}

exports
    firebird_udr_plugin
;

begin
end.
