(*
    Unit       : fbsys_register
    Date       : 2022-11-09
    Compiler   : Delphi XE3
    ©Copyright : Shalamyansky Mikhail Arkadievich
    Contents   : Register UDR function for fb_sys module
    Project    : https://github.com/shalamyansky/fb_sys
    Company    : BWR
*)
(*
    References and thanks:

    Denis Simonov. Firebird UDR writing in Pascal.
                   2019, IBSurgeon

*)
//DDL definition
(*
set term ^;

create or alter package sys
as begin

procedure sleep(
    milliseconds integer
);

function read_file(
    path varchar(8191) character set UTF8
)returns blob;

end^

recreate package body sys
as
begin

procedure sleep(
    milliseconds integer
)
external name
    'fb_sys!sleep'
engine
    udr
;

function read_file(
    path varchar(8191) character set UTF8
)returns blob
external name
    'fb_sys!read_file'
engine
    udr
;

end^

set term ;^
*)
unit fbsys_register;

interface

uses
    firebird
;

function firebird_udr_plugin( AStatus:IStatus; AUnloadFlagLocal:BooleanPtr; AUdrPlugin:IUdrPlugin ):BooleanPtr; cdecl;


implementation


uses
    fbsys
;

var
    myUnloadFlag    : BOOLEAN;
    theirUnloadFlag : BooleanPtr;

function firebird_udr_plugin( AStatus:IStatus; AUnloadFlagLocal:BooleanPtr; AUdrPlugin:IUdrPlugin ):BooleanPtr; cdecl;
begin
    AUdrPlugin.registerProcedure( AStatus, 'sleep',     fbsys.TSleepFactory.Create()    );
    AUdrPlugin.registerFunction(  AStatus, 'read_file', fbsys.TReadFileFactory.Create() );

    theirUnloadFlag := AUnloadFlagLocal;
    Result          := @myUnloadFlag;
end;{ firebird_udr_plugin }

procedure InitalizationProc;
begin
    IsMultiThread := TRUE;
    myUnloadFlag  := FALSE;
end;{ InitalizationProc }

procedure FinalizationProc;
begin
    if( ( theirUnloadFlag <> nil ) and ( not myUnloadFlag ) )then begin
        theirUnloadFlag^ := TRUE;
    end;
end;{ FinalizationProc }

initialization
begin
    InitalizationProc;
end;

finalization
begin
    FinalizationProc;
end;

end.
