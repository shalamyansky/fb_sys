(*
    Unit       : fbsys
    Date       : 2023-01-03
    Compiler   : Delphi XE3
    ©Copyright : Shalamyansky Mikhail Arkadievich
    Contents   : Firebird UDR OS wrapper functions
    Project    : https://github.com/shalamyansky/fb_sys
    Company    : BWR
*)

//DDL definition
(*

create or alter procedure sleep(
    milliseconds integer
);

create or alter function read_file(
    path varchar(8191) character set UTF8
)returns blob
external name
    'fb_sys!read_file'
engine
    udr
;

*)

unit fbsys;

interface

uses
    SysUtils
  , Windows
  , firebird  // https://github.com/shalamyansky/fb_common
  , fbudr     // https://github.com/shalamyansky/fb_common
;


type

{ sleep }

TSleepFactory = class( TBwrProcedureFactory )
  public
    function newItem( AStatus:IStatus; AContext:IExternalContext; AMetadata:IRoutineMetadata ):IExternalProcedure; override;
end;{ TSleepFactory }

TSleepProcedure = class( TBwrProcedure )
  const
    INPUT_FIELD_MILLISECONDS = 0;
  public
    function open( AStatus:IStatus; AContext:IExternalContext; AInMsg:POINTER; AOutMsg:POINTER ):IExternalResultSet; override;
end;{ TSleepProcedure }

TReadFileFactory = class( TBwrFunctionFactory )
  public
    function newItem( AStatus:IStatus; AContext:IExternalContext; AMetadata:IRoutineMetadata ):IExternalFunction; override;
end;{ TReadFileFactory }

TReadFileFunction = class( TBwrFunction )
  const
    INPUT_FIELD_PATH    = 0;
    OUTPUT_FIELD_RESULT = 0;
  public
    procedure execute( AStatus:IStatus; AContext:IExternalContext; AInMsg:POINTER; AOutMsg:POINTER ); override;
end;{ TReadFileFunction }


implementation

uses
    fbutils   // https://github.com/shalamyansky/fb_common
;

{ TSleepFactory }

function TSleepFactory.newItem( AStatus:IStatus; AContext:IExternalContext; AMetadata:IRoutineMetadata ):IExternalProcedure;
begin
    Result := TSleepProcedure.create( AMetadata );
end;{ TSleepFactory.newItem }

{ TSleepProcedure }

function TSleepProcedure.open( AStatus:IStatus; AContext:IExternalContext; aInMsg:POINTER; aOutMsg:POINTER ):IExternalResultSet;
var
    Milliseconds     : LONGINT;
    MillisecondsNull : WORDBOOL;
    MillisecondsOk   : BOOLEAN;
begin
    inherited open( AStatus, AContext, aInMsg, aOutMsg );

    MillisecondsOk := RoutineContext.ReadInputLongint( AStatus, TSleepProcedure.INPUT_FIELD_MILLISECONDS, Milliseconds, MillisecondsNull  );
    if( MillisecondsNull )then begin
        Milliseconds := 0;
    end;

    Windows.Sleep( Milliseconds );

    Result := nil;
end;{ TSleepProcedure.open }

{ TReadFileFactory }

function TReadFileFactory.newItem( AStatus:IStatus; AContext:IExternalContext; AMetadata:IRoutineMetadata ):IExternalFunction;
begin
    Result := TReadFileFunction.create( AMetadata );
end;{ TReadFileFactory.newItem }

procedure TReadFileFunction.execute( AStatus:IStatus; AContext:IExternalContext; aInMsg:POINTER; aOutMsg:POINTER );
var
    Path   : UnicodeString;
    Result : TBytes;
    PathNull, ResultNull : WORDBOOL;
    PathOk,   ResultOk   : BOOLEAN;
begin
    inherited execute( AStatus, AContext, aInMsg, aOutMsg );
    System.Finalize( Path   );
    System.Finalize( Result );
    ResultNull := TRUE;
    ResultOk   := FALSE;
    PathOk     := RoutineContext.ReadInputString( AStatus, TReadFileFunction.INPUT_FIELD_PATH, Path, PathNull );
    if( ( not PathNull ) and ( Length( Path ) > 0 ) )then begin
        ResultNull := not ReadFile( Path, Result );
    end;
    ResultOk := RoutineContext.WriteOutputBlob( AStatus, TReadFileFunction.OUTPUT_FIELD_RESULT, Result, ResultNull );
end;{ TReadFileFunction.execute }

end.
