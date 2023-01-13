# fb_sys
Firebird UDR module to call miscellaneous OS routines.

## Routines

Now module provides only 2 routines. The set will be replenished as necessary.

## procedure *sleep*

    procedure sleep( milliseconds integer );

This is executable procedure. Forces execution thread to sleep for a time. 


## function *read_file*

    function read_file( path string ) returns blob;

Reads the entire contents of file into blob. **Path** is filesystem path and/or in-zip path which may look as

    c:\projects\archive.zip/source/readme.txt

where archive.zip can be either a zip achive or a filesystem folder. Symbols "\\" and "/" are equavalient.

The **string** type is any firebird **char**, **varchar** or **blob sub_type text** type of any length an character set UTF8 or WIN1251.   
    

## Installation


0. Download a release package.

1. Copy fb_xml.dll to %firebird%\plugins\udr
   where %firebird% is Firebird 4.0(3.0) server root directory.
   Make sure library module matches the Firebird bitness.

2. Select script fb_sys_utf8.sql or fb_sys_win1251.sql.

3. Connect to target database and execute the script.


## Using

You can use binaries as you see fit.

If you get code or part of code please keep my name and a link [here](https://github.com/shalamyansky/fb_xml).   
