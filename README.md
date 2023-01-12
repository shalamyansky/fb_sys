# fb_sys
Firebird UDR module to call miscellaneous OS routines.

## Routines

## procedure *sleep*

    procedure sleep( milliseconds integer );

This is executable procedure. Forces execution thread to sleep for a time. 


## function *read_file*

    function read_file( path string ) returns blob;

Reads the entire contents of file into blob. **Path** is filesystem path and/or in-zip path which may look as

	c:\projects\archive.zip/source/readme.txt

where archive.zip can be either a zip achive or a filesystem folder. Symbols "\" and "/" are equavalient.

The **string** type is any firebird char(), varchar() or blob sub_type text string type of any length an character set UTF8 or WIN1251.   
    
