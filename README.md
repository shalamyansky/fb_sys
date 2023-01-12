# fb_sys
Firebird UDR module to call miscellaneous OS routines.

## Routines

## procedure *sleep*

    procedure sleep( milliseconds integer );

This is executable procedure. Forces execution thread to sleep for a time. 


## function *read_file*

    function read_file( path string ) returns blob;

Reads all the contents of file to blob. **Path** is file system path and/or in-zip path and can look as

	c:\projects\archive.zip/source/readme.txt

where archive.zip can be either zip achive or file system folder. Symbols "\" and "/" are equavalient.

Type **string** is any firebird string type char(), varchar() or blob sub_type text of any length an character set UTF8 or WIN1251.   
    
