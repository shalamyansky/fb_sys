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
