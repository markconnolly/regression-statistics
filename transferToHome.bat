@echo off

rem  Batch file uses Connect:Direct Secure Plus to move files in the
rem  root of the user's mapped t: drive in the HSD to the user's 
rem  home directory in the core.  The home directory must be contained
rem  in a parameter file that is specific to the user and named with the
rem  user's HSD name with the suffix .parm.  
rem  Example file: a12345-h1.parm.
rem  Example file contents: \\wil-home\a12345$

rem  Permissioned users are those set up with t: drives in the HSD

rem  This bat file should be available for read and execute for all permissioned users.
rem  Should be placed in a global context for access by all permissioned users.
rem  Create an icon to execte this bat and publish for all permissioned user.

rem Contains all of the files containing users set up for transfer.
rem Read-only for users.
rem                         *** Need to identify location ***
set CDXFER.PARMHOME=.\transfer\


rem Location of the connect direct software.
rem Read and execute for users.
rem                         *** Need to identify location ***
set CDXFER.CDHOME=.\connectdirect\


rem derive name of the parameter file
set parmfile=%CDXFER.PARMHOME%%username%.parm

set message=complete
if exist %parmfile% (
    rem continue proessing 
) else (
	set message=Parameter file %username%.parm was not found.  Must be created for user before transfers can be made.
    goto eof
)


set /p homeDirectory=< %parmfile%
echo Will move files to %homeDirectory% (user's h: identified in core as defined in %parmfile%)


rem 
rem Parameterize and execute C:D command
rem Any Secure Plus issues?
rem where to put log?
rem where to collect log?
rem how to cleanup log?
rem 
direct -x ....


:eof
    echo %message%
    echo processing status from Connect Direct
    pause Hit any key to close
