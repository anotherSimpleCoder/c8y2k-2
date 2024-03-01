function normalPath() {
    $installPath = "${Env:HOMEPATH}\.c8y2k"
    Write-Host "Installing c8y2k in $installPath"
    
    try {
        Copy-Item .\c8y2k.ps1 $installPath\c8y2k.ps1
        Write-Output "`$Env:Path+=$installPath" >> $PROFILE
    } catch {
        Write-Host "Error when installing c8y2k"
        exit 1
    }

	Write-Host "c8y2k has been installed successfully"
	Write-Host "Enter 'c8y2k' in order to use it"
}

function customPath() {
    $entered = $false
    while($entered -ne $true) {
        $installPath = Read-Host "Please enter your installation path"
    
        if($installPath.Length -eq 0) {
            Write-Host "Please enter a valid install path!"
        } else {
            $entered=$true
        }
    }

    try {
        Copy-Item .\c8y2k.ps1 $installPath
    } catch {
        Write-Error "Error when installing c8y2k!"
        exit 1
    }
}

Write-Host "                                   .::     "
Write-Host "           .:               .:::.: .::     "
Write-Host "   .::: .::  .::  .::   .::.:    .:.::  .::"
Write-Host " .::   .::     .:  .:: .::     .:: .:: .:: "
Write-Host ".::      .:: .:      .:::    .::   .:.::   "
Write-Host " .::   .::     .::    .::  .::     .:: .:: "
Write-Host "   .:::  .::::       .::   .:::::::.::  .::"
Write-Host "                   .::                     "
Write-Host
Write-Host "c8y2k Installer"
Write-Host

$entered = $false
while($entered -ne $true) {
    Write-Host "1) Install on normal path (${Env:HOMEPATH}\.c8y2k) <recommended>."
    Write-Host "2) Install on custom path."
    Write-Host "3) Cancel installation."
    $choice = Read-Host "install"

    switch($choice) {
        1 {
            normalPath
        }

        2 {
            customPath
        }

        3 {
            exit
        }

        default {
            Write-Host "Invalid choice!"
        }
    }
}