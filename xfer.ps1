$snode  = "CD.FILEXFRE1.WIN"
$direct = """C:\Program Files (x86)\Sterling Commerce\Connect Direct v4.6.00\Common Utilities\direct.exe"""
$cddef  = """C:\Program Files (x86)\Sterling Commerce\Connect Direct v4.6.00\Common Utilities\cddef.bin"""

$sourcedrive = "T"

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
