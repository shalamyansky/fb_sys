set term ^;

create or alter package sys
as begin

procedure sleep(
    milliseconds integer
);

function read_file(
    path varchar(32765) character set WIN1251
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
    path varchar(32765) character set WIN1251
)returns blob
external name
    'fb_sys!read_file'
engine
    udr
;

end^

set term ;^
