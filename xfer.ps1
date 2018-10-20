$snode  = "CD.FILEXFRE1.WIN"
$direct = """C:\Program Files (x86)\Sterling Commerce\Connect Direct v4.6.00\Common Utilities\direct.exe"""
$cddef  = """C:\Program Files (x86)\Sterling Commerce\Connect Direct v4.6.00\Common Utilities\cddef.bin"""


$sourcedrive = "H"

$sourceshare = (get-psdrive $sourcedrive).DisplayRoot
if ($sourceshare -eq $null) {
    $message = "`nThe source drive $sourcedrive must map to an available UNC share.`nWithout the correct mapping, files cannot be moved.`n"
    throw $message
}


if ((Get-ChildItem -File T:\ | Measure-Object).count -eq 0) {
    write-host "no files to move"
    [void][System.Console]::ReadKey($true)
    exit
} else {
    write-host "files to move "
    [void][System.Console]::ReadKey($true)
    exit
}


$sourcefiles = """$sourceshare\*.*"""

$parmhome  =  "p:\usercorehdrives\"
$parmfile  =  "$parmhome$env:USERNAME\"

===================================================

@echo off

rem  Batch file uses Connect:Direct Secure Plus to move files in the 
rem  root of the user's mapped t: drive in the HSD to the user's 
rem  home directory in the core.  The home directory must be contained 
rem  in a parameter file that is specific to the user and named with the 
rem  user's HSD name with the suffix .parm 

rem  Example file:             a12345-h1.parm 
rem  Example file contents:    \\wil-homedrive99\a12345$\

rem  Permissioned users are those set up with t: drives in the HSD

rem  This bat file should be available for read and execute for all permissioned users.
rem  Should be placed in a global context for access by all permissioned users.
rem  Create an icon to execte this bat and publish for all permissioned user.


rem various locations
set XFER.SNODE=CD.FILEXFRE1.WIN
set XFER.CDHOME="C:\Program Files (x86)\Sterling Commerce\Connect Direct v4.6.00\Common Utilities\"
set XFER.USERDEFBIN="C:\Program Files (x86)\Sterling Commerce\Connect Direct v4.6.00\Common Utilities\cddef.bin"

set xfer.parmhome=p:\usercorehdrives\
set xfer.parmfile=%xfer.parmhome%%username%.parm

set xfer.sourcedrive=t:
set xfer.sourcefiles=%xfer.sourcedrive%\*.*
set xfer.workingdir=%xfer.sourcedrive%\cdprocessing\

rem mkdir the working directory, don't show message if it already exists
mkdir %xfer.workingdir% 2> nul
set xfer.cdinputfile=%xfer.workingdir%latestCDcommands.txt
set xfer.cdlogfile=%xfer.workingdir%latestCDlog.txt
set xfer.batlogfile=%xfer.workingdir%latestbatlog.txt

> %xfer.batlogfile% echo executing %~nx0 on %date% %time% 


rem Make sure everything is as it should be
if not exist %XFER.CDHOME% (
     >> %xfer.batlogfile% (
         echo The expected location for Connect:Direct utilities is : %XFER.CDHOME%. 
         echo This location does not exist or is not accessible.  Cannot proceed.
     )
     goto eof
)
if not exist %xfer.parmhome% (
	 >> %xfer.batlogfile% (
        echo The expected location for user-specific files containing
        echo core home directory information is %xfer.parmhome%.
        echo Location does not exist or is not accessible. Cannot proceed.
     )
     goto eof
)
if not exist %xfer.sourcedrive% (
	 >> %xfer.batlogfile% (
        echo Drive %xfer.sourcedrive% not available for user.
        echo Must be mapped before transfers can be made.
     )
     goto eof
)
if not exist %xfer.parmfile% (
	 >> %xfer.batlogfile% (
        echo Parameter file %xfer.parmfile% was not found.
        echo Must be created for user before transfers can be made.
        echo Must contain user's core network share name.
     )
     goto eof
)


rem Read file for user's core homeDirectory 
rem This is the same person's h: drive mapped to the person's core account
set /p homeDirectory=< %xfer.parmfile%
echo.
echo Will move files to %homeDirectory% (user's h: identified in core as defined in %xfer.parmfile%)

rem create C:D process code as a file that will be input to the C:D command line
>%xfer.cdinputfile% (
    echo submit maxdelay=00:05:00
    echo transferToHome PROCESS
    echo    ^&date='%%SUBDATE1'
	echo    ^&time='%%SUBTIME'
	echo.
    echo     SNODE=%XFER.SNODE%
    echo.
    echo     STEP1 COPY FROM ^(PNODE
    echo         FILE="%xfer.sourcefiles%"
    echo     ^)
    echo     TO ^(SNODE
	echo        FILE="%homeDirectory%&date&time.*"
    echo        DISP=^(RPL^)
    echo     ^)

    echo pend;
    echo quit;
)

echo.
echo ******  Showing commands input to CD  ******
type %xfer.cdinputfile%
echo.
echo.

echo.
set xfer.cmd=%XFER.CDHOME%direct -x -f%XFER.USERDEFBIN% ^<%xfer.cdinputfile% ^> %xfer.cdlogfile%
echo will execute "%xfer.cmd%"
>> %xfer.batlogfile% echo will execute "%xfer.cmd%"
echo.
pause
%xfer.cmd%

set respcode=%errorlevel%
if %respcode% NEQ 0 (
	 >> %xfer.batlogfile% (
       echo.
       echo Something went wrong in the transfer
       echo C:D response code was %respcode%
       echo Check log file %xfer.cdlogfile% for additional information
       echo.
     )
) else (
	>> %xfer.batlogfile% Processing completed successfully.
	echo.
	echo deleting %xfer.sourcefiles%
    echo Latest transfer information in %xfer.workingdir%
    rem del /q %xfer.sourcefiles%
    echo.
)


:eof
     type %xfer.batlogfile%
     pause Hit any key to close
     


