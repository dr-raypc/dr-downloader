### Proj:	Dr. Downloader v3.3
### Date:	01/28/2021
### Auth:	Script created by Raymond Mayer
### Upd:	06/24/2022
### Iss:	When running this script as a different user (local admin), it will create the download location in that users profile. Must change it to c:\users\public\desktop\*


# ======================================================================================================= #
# ======================================================================================================= #
# 										VARIABLES
# ======================================================================================================= #
# ======================================================================================================= #


Write-Progress -Activity "Starting Dr. Ray Downloader" -Status "Initializing variables . . ." -PercentComplete 10
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
[Version]$RunningVersion = '3.0.2.0'
$binpath = "C:\Program Files (x86)\Dr. Ray Downloader\bin"
$DesktopPath = [Environment]::GetFolderPath("Desktop")
#$downloadlocation = "$DesktopPath\Dr. Ray Downloads"
$downloadlocation = "C:\temp\Dr. Ray Downloads"
$tmpfolder = "C:\temp"
$tmpbinpath = "C:\temp\Dr. Ray Downloader\bin"
$RootFolder = "$PSScriptRoot"
$ENV:Path += ";$binpath"
$StartFolder = $ENV:APPDATA + "\Microsoft\Windows\Start Menu\Programs\Dr. Downloader"
$drrayTempRun = 0

#Param (
#[Parameter(Position = 1, Mandatory = $false)]
#[Switch]
#$portable
#)


# ======================================================================================================= #
# ======================================================================================================= #
# 										FUNCTIONS
# ======================================================================================================= #
# ======================================================================================================= #


Function DownloadFile {
	Param(
		[String]$url,
		[String]$dest
	)
	(New-Object System.Net.WebClient).DownloadFile("$url", "$dest")
}


Function DownloadYoutube-dl {
	Write-Host "`n[+] Downloading youtube-dl binary . . ." -ForegroundColor "Yellow"
	DownloadFile "http://yt-dl.org/downloads/latest/youtube-dl.exe" "$binpath\dl.exe"
}


Function DownloadFFmpeg {
	Write-Host "`n[+] Downloading ffmpeg files . . ." -ForegroundColor "Yellow"
	DownloadFile "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z" "$binpath\ffmpeg_latest.7z"
	Write-Host "`n[+] Expanding ffmpeg 7-Zip archive . . ." -ForegroundColor "Yellow"
#	Expand-Archive -Path "$binpath\ffmpeg_latest.7z" -DestinationPath "$binpath"
	Expand-7Zip -ArchiveFileName "$binpath\ffmpeg_latest.7z" -TargetPath "$binpath"
	Copy-Item -Path "$binpath\ffmpeg-*\bin\*" -Destination "$binpath" -Recurse -Filter "*.exe" -Force -ErrorAction SilentlyContinue
	Remove-Item -Path "$binpath\ffmpeg_latest.7z" -Force -ErrorAction SilentlyContinue
	Remove-Item -Path "$binpath\ffmpeg-*" -Recurse -Force -ErrorAction SilentlyContinue
}


Function DownloadTEMPYoutube-dl {
	Write-Host "`n[+] Downloading youtube-dl binary . . ." -ForegroundColor "Yellow"
	DownloadFile "http://yt-dl.org/downloads/latest/youtube-dl.exe" "C:\temp\Dr. Ray Downloader\bin\dl.exe"
}


Function DownloadTEMPFFmpeg {
	Write-Host "`n[+] Downloading ffmpeg files . . ." -ForegroundColor "Yellow"
	DownloadFile "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z" "C:\temp\Dr. Ray Downloader\bin\ffmpeg_latest.7z"
	Write-Host "`n[+] Expanding ffmpeg 7-Zip archive . . ." -ForegroundColor "Yellow"
#	Expand-Archive -Path "$binpath\ffmpeg_latest.7z" -DestinationPath "$binpath"
	Expand-7Zip -ArchiveFileName "C:\temp\Dr. Ray Downloader\bin\ffmpeg_latest.7z" -TargetPath "$binpath"
	Copy-Item -Path "C:\temp\Dr. Ray Downloader\bin\ffmpeg-*\bin\*" -Destination "C:\temp\Dr. Ray Downloader\bin" -Recurse -Filter "*.exe" -Force -ErrorAction SilentlyContinue
	Remove-Item -Path "C:\temp\Dr. Ray Downloader\bin\ffmpeg_latest.7z" -Force -ErrorAction SilentlyContinue
	Remove-Item -Path "C:\temp\Dr. Ray Downloader\bin\ffmpeg-*" -Recurse -Force -ErrorAction SilentlyContinue
}


Function UpdateScript {
	DownloadFile "https://raw.githubusercontent.com/dr-raypc/dr-downloader/main/bin/drray-version" "$tmpfolder\version-file.txt"
	[Version]$NewestVersion = Get-Content "$tmpfolder\version-file.txt" | Select -Index 0
	Remove-Item -Path "$tmpfolder\version-file.txt" -Force
	
	If ($NewestVersion -gt $RunningVersion) {
		Write-Host "`nA new version of Dr. Ray Downloader is available: v$NewestVersion" -ForegroundColor "Yellow"
		$MenuOption = Read-Host "`nUpdate to this version? [y/n]" -ForegroundColor "Yellow"
		
		If ($MenuOption -like "y" -or $MenuOption -like "yes") {
			DownloadFile "https://raw.githubusercontent.com/dr-raypc/dr-downloader/main/dr-downloader.ps1" "C:\Program Files (x86)\Dr. Ray Downloader\dr-downloader.ps1"
		}
			Write-Host "`nUpdate complete. Please restart the script." -ForegroundColor "Green"
			Start-Sleep 3
			Exit 0
		}
		Else {
			Return
		} 
		ElseIf ($NewestVersion -eq $RunningVersion) {
		Write-Host "`nThe running version of PowerShell-Youtube-dl is up-to-date." -ForegroundColor "Green"
	}
	Else {
		Write-Host "`n[ERROR] Script version mismatch. Re-installing the script is recommended." -ForegroundColor "Red" -BackgroundColor "Black"
		Start-Sleep 5
	}
}


function drrayUpdate {
	Write-Host ""
	Write-Host "                              DR. RAY DOWNLOADER v3.3 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               DR. RAY     UPDATER          "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	Write-Host "`n[+] Starting Dr. Ray Updater - Checking files . . ." -ForegroundColor "Yellow"
	DownloadYoutube-dl
	DownloadFfmpeg
	Start-Sleep 1
	Write-Host "`n[+] Checking for Dr. Ray updates . . . " -ForegroundColor "Yellow"
	UpdateScript
	Write-Host "`n[x] Update completed successfully." -ForegroundColor "Green"
	mainRun
}


function drrayInstallCheck {
	if (!(Test-path -Path "C:\Program Files (x86)\Dr. Ray Downloader")) {
		Write-Host "`n[ERROR]: Dr. Ray Downloader is not installed. Would you like to install it?`n" -ForegroundColor "Red" -BackgroundColor "Black"
		$installdrray = (Read-Host "Y/N")
		if ($installdrray -like "y" -or $installdrray -like "yes") {
			drrayInstall
		} else {
			Write-Host "`n[ERROR]: Missing dependencies. Would you like to install Dr. Ray Downloader in a temporary location?`n" -ForegroundColor "Red" -BackgroundColor "Black"
			$installDrRayTemp = (Read-Host "Y/N")
			if ($installDrRayTemp -like "y" -or $installDrRayTemp -like "yes") {
				$drrayTempRun = 1
				drrayTempInstall
			} else {
				Write-Host "`n[ERROR]: Dr. Ray Downloader was not installed. Please install Dr. Ray Downloader to continue.`n" -ForegroundColor "Red" -BackgroundColor "Black"
				exit 1
			}
		}
	}
}


function drrayInstall {
	Write-Progress -Activity "[+] Installing Dr. Ray Downloader" -Status "Installing . . ." -PercentComplete 15
	Write-Host "`n[+] Installing Dr. Ray Downloader . . ." -ForegroundColor "Yellow"
	New-Item -ItemType Directory -Path $downloadlocation -Force -ErrorAction SilentlyContinue | out-null
	Write-Progress -Activity "[+] Installing Dr. Ray Downloader" -Status "Installing . . ." -PercentComplete 40
	New-Item -ItemType Directory -Path "C:\Program Files (x86)\Dr. Ray Downloader" -Force -ErrorAction SilentlyContinue | out-null
	New-Item -ItemType Directory -Path "C:\Program Files (x86)\Dr. Ray Downloader\bin" -Force -ErrorAction SilentlyContinue | out-null
	New-Item -ItemType Directory -Path "$StartFolder" -Force -ErrorAction SilentlyContinue | Out-Null
	Write-Progress -Activity "[+] Installing Dr. Ray Downloader" -Status "Installing . . ." -PercentComplete 65
#	$WshShell = New-Object -comObject WScript.Shell
#	$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\Dr. Downloads.lnk")
#	$shortcut.TargetPath = "C:\ProgramData\Dr. Downloader\Dr. Downloads"
#	$shortcut.save()
	Write-Progress -Activity "[+] Installing Dr. Ray Downloader" -Status "Installing . . ." -PercentComplete 90
	Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Dr. Ray Downloader" -Force -ErrorAction SilentlyContinue
	TRY {
	#	Copy-Item "$PSScriptRoot\dr-downloader-v3.ps1" -Destination "C:\Program Files (x86)\Dr. Ray Downloader" -Force
	#	$WshShell = New-Object -comObject WScript.Shell
	#	$Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\Dr. Ray Downloader.lnk")
	#	$shortcut.TargetPath = "C:\Program Files (x86)\Dr. Ray Downloader\dr-downloader.ps1"
	#	$shortcut.save()
	} CATCH {
		DownloadFile "https://raw.githubusercontent.com/dr-raypc/dr-downloader/main/dr-downloader.ps1" "C:\Program Files (x86)\Dr. Downloader\dr-downloader.ps1"
	} FINALLY {
		DownloadFFmpeg
		DownloadYoutube-dl
	}
	Write-Progress -Activity "[+] Installing Dr. Ray Downloader" -Status "Installing . . ." -Completed
}


function drrayTempInstall {
	Write-Progress -Activity "[+] Installing Dr. Ray Downloader in a temporary location. . ." -Status "Temporary Installation. . ." -PercentComplete 15
	Write-Host "`n[+] Installing TEMP Dr. Ray Downloader . . ." -ForegroundColor "Yellow"
	New-Item -ItemType Directory -Path $tmpfolder -Force -ErrorAction SilentlyContinue | out-null
	New-Item -ItemType Directory -Path "C:\temp\Dr. Ray Downloader" -Force -ErrorAction SilentlyContinue | out-null
	Write-Progress -Activity "[+] Installing TEMP Dr. Ray Downloader" -Status "Temporary Installation. . ." -PercentComplete 40
	New-Item -ItemType Directory -Path $tmpbinpath -Force -ErrorAction SilentlyContinue | out-null
	Write-Progress -Activity "[+] Installing TEMP Dr. Ray Downloader" -Status "Temporary Installation. . ." -PercentComplete 65
	Add-MpPreference -ExclusionPath "C:\temp\Dr. Ray Downloader" -Force -ErrorAction SilentlyContinue
	Write-Progress -Activity "[+] Installing Dr. Ray Downloader" -Status "Installing . . ." -PercentComplete 90
	TRY {
		DownloadFile "https://raw.githubusercontent.com/dr-raypc/dr-downloader/main/dr-downloader.ps1" "C:\temp\Dr. Ray Downloader\dr-downloader.ps1"
	} CATCH {
		#DownloadFile "https://raw.githubusercontent.com/dr-raypc/dr-downloader/main/dr-downloader.ps1" "C:\temp\Dr. Ray Downloader\dr-downloader.ps1"
	} FINALLY {
		DownloadTEMPFFmpeg
		DownloadTEMPYoutube-dl
	}
	Write-Progress -Activity "[+] Installing TEMP Dr. Ray Downloader" -Status "Temporary Installation. . ." -Completed
	Set-Location -Path "C:\temp\Dr. Ray Downloader" -ErrorAction SilentlyContinue
}


function audioRun {
	Write-Host ""
	Write-Host "                              DR. RAY DOWNLOADER v3.3 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               DR. RAY     AUDIO DOWNLOADER          "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	$audioURL = (Read-Host "`n   URL").Trim()
	if ($audioURL -eq "M" -or $audioURL -eq "m") {
		mainRun
	}
	Write-Host ""
	Write-Host ""
	Write-Host "`nDownloading audio from: $audioURL`n"
	$audioDWNLD = "dl -o ""$downloadlocation\%(title)s.%(ext)s"" --format bestaudio -x --audio-format mp3 --audio-quality 0 --ignore-errors --console-title --no-mtime ""$audioURL"""
	Invoke-Expression "$audioDWNLD"
	Write-Host ""
}


function  videoRun {
	Write-Host ""
	Write-Host "                              DR. RAY DOWNLOADER v3.3 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               DR. RAY     VIDEO DOWNLOAER         "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	$videoURL = (Read-Host "`n   URL").Trim()
	if ($videoURL -eq "M" -or $videoURL -eq "m") {
		mainRun
	}
	Write-Host ""
	Write-Host ""
	Write-Host "`nDownloading video from: $videoURL`n"
	$videoDWNLD = "dl -o ""$downloadlocation\%(title)s.%(ext)s"" --ignore-errors --console-title --no-mtime ""$videoURL"""
	Invoke-Expression "$videoDWNLD"
	Write-Host ""
}


function drrayHelp {
	Write-Host ""
	Write-Host "                              DR. RAY DOWNLOADER v3.3 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               DR. RAY     HELPER          "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	Write-Host "   Dr. Ray Downloader (or Dr. Downloader) is a small, lightweight application"
	Write-Host "     coded in PowerShell that operates the youtube-dl command line. This"
	Write-Host "       application allows any user to download audio or video from media"
	Write-Host "              websites such as YouTube, SoundCloud, LiveLeak, etc."
	Write-Host ""
	Write-Host "        When you are done, please exit the application using the #5 option"
	Write-Host ""
	Write-Host ""
	Write-Host "        Press enter to return to the main menu or type UNINSTALL to"
	Write-Host "         remove Dr. Ray Downloader from your PC. Uninstalling will"
	Write-Host "                 not remove downloaded audio/video files."
	Write-Host ""
	Write-Host ""
	$helpPrompt = (Read-Host "`n")
	if ($helpPrompt -like "uninstall") {
		drrayUninstall
	} else {
		mainRun
	}
}


function drrayExit {
	Start-Process $downloadlocation
	Set-Location $downloadlocation
	exit 0
}


function drrayUninstall {
	if (Test-Path -Path "C:\Program Files (x86)\Dr. Ray Downloader\*") {
		Clear-Host
		Write-Host ""
		Write-Host "                              DR. RAY DOWNLOADER v3.3"
		Write-Host "                                      _____  "
		Write-Host "                                     ( o o ) "
		Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
		Write-Host "                               DR. RAY     UNINSTALLER          "
		Write-Host " --------------------------------------------------------------------------------"
		Write-Host ""
		Write-Host ""
		Set-Location -Path $DesktopPath -ErrorAction SilentlyContinue
		Write-Host "`n[+] Removing Start Menu Shortcuts . . ." -ForegroundColor "Yellow"
		if (test-path -path $StartFolder) {
			Remove-Item -Path $StartFolder -Force -ErrorAction SilentlyContinue
		}
		Write-Host "`n[+] Removing Dr. Ray Downloader Components . . ." -ForegroundColor "Yellow"
		if (test-path -path "C:\Program Files (x86)\Dr. Ray Downloader\bin") {
			Remove-Item -Path "C:\Program Files (x86)\Dr. Ray Downloader\bin" -Recurse -Force -ErrorAction SilentlyContinue
		}
		Write-Host "`n[+] Removing Dr. Ray Downloader Installation folder . . ." -ForegroundColor "Yellow"
		if (test-path -path "C:\Program Files (x86)\Dr. Ray Downloader") {
			Remove-Item -Path "C:\Program Files (x86)\Dr. Ray Downloader" -Recurse -Force -ErrorAction SilentlyContinue
		}
		Start-Sleep 5
		if (!(Test-path -Path "C:\Program Files (x86)\Dr. Ray Downloader")) {
			Write-Host "`n[x] Successfully uninstalled Dr. Ray Downloader!" -ForegroundColor "Green"
			Write-Host "`n[x] Dr. Ray Downloader will now exit." -ForegroundColor "Green"
			Write-Host ""
			exit 0
		}
	}
}


# ======================================================================================================= #
# ======================================================================================================= #
# 									MAIN FUNCTION
# ======================================================================================================= #
# ======================================================================================================= #


function mainRun {
	
	if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
 		 $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  	Start-Process powershell -Verb runAs -ArgumentList $arguments
  	Break
	}

	Write-Progress -Activity "Starting Dr. Ray Downloader" -Status "Checking main files . . ." -PercentComplete 20

	If (([environment]::Is64BitOperatingSystem) -eq $false) {
		Write-Host "[ERROR]: Dr. Ray Downloader only supports 64 bit Operating Systems." -ForegroundColor "Red" -BackgroundColor "Black"
		End
	}

	If ($PSVersionTable.PSVersion.Major -lt 5) {
		Write-Host "[ERROR]: Your PowerShell installation is not version 5.0 or greater.`n        This script requires PowerShell version 5.0 or greater to function.`n        You can download PowerShell version 5.0 at:`n            https://www.microsoft.com/en-us/download/details.aspx?id=50395" -ForegroundColor "Red" -BackgroundColor "Black"
		Start-Sleep 10
		End
	}
	
#	if (!(test-path -path "C:\Program Files (x86)\Dr. Ray Downloader\*")) {
#		drrayInstallCheck
#	}

	if ($drrayTempRun -eq 0) {
		drrayInstallCheck
	}
	
	Write-Progress -Activity "Starting Dr. Ray Downloader" -Status "Checking main files . . ." -PercentComplete 30
	
	if (-not(Get-InstalledModule 7Zip4PowerShell -ErrorAction SilentlyContinue)) {
		Set-PSRepository PSGallery -InstallationPolicy Trusted
		Install-Module -Name 7Zip4PowerShell -Confirm:$false -Force
	}
	
	Write-Progress -Activity "Starting Dr. Ray Downloader" -Status "Checking main files . . ." -PercentComplete 55
	
	Try {
		$installedsoftware = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName
		Write-Progress -Activity "Starting Dr. Ray Downloader" -Status "Checking main files . . ." -PercentComplete 75
		if (-not($InstalledSoftware -like "*Microsoft Visual C++ 2010  x86 Redistributable*")) {
			Write-Host "[ERROR]: Microsoft Visual C++ 2010 x86 Redistributable package must be installed. It can be downloaded here:`n
			https://www.microsoft.com/en-us/download/details.aspx?id=26999" -ForegroundColor "Red"  -BackgroundColor "Black"
			Write-Host ""
			$msvisredistdownload = Read-Host "Should we download and install the Microsoft Visual C++ 2010 x86 Redistributable package?"
			if ($msvisredistdownload -like "y" -or $msvisredistdownload -like "yes") {
				DownloadFile "https://github.com/dr-raypc/dr-downloader/blob/main/bin/vcredist_x86.exe?raw=true" "$tmpfolder\vcredist_x86.exe"
				Start-Process "$tmpfolder\vcredist_x86.exe" -Force
				exit 0
			}
		}
	} Catch {
		Write-Host "[ERROR]: Microsoft Visual C++ 2010 x86 Redistributable package must be installed. It can be downloaded here:" -ForegroundColor "Red"
		Write-Host "https://www.microsoft.com/en-us/download/details.aspx?id=26999" -ForegroundColor "Red"
	}
	
	Write-Progress -Activity "Starting Dr. Ray Downloader" -Status "Loading Dr. Ray Downloader . . ." -PercentComplete 90
	
	if (!(Test-Path -Path $downloadlocation)) {
		New-Item -ItemType Directory -Path $downloadlocation -Force -ErrorAction SilentlyContinue | Out-Null
	}
	
	if (!(test-path -path $tmpfolder)) {
		New-Item -ItemType Directory -Path $tmpfolder -Force -ErrorAction SilentlyContinue | Out-Null
	}
	
	if ($drrayTempRun -eq "1") {
		If (!(test-path -path "$tmpbinpath\dl.exe")) {
			Write-Host "`nYouTube-dl not found. Downloading and installing to: ""$tmpbinpath"" ...`n" -ForegroundColor "Yellow"
			DownloadTEMPYoutube-dl
		}
	} elseif ($drrayTempRun -eq "0") {
		If (!(test-path -path "$binpath\dl.exe")) {
			Write-Host "`nYouTube-dl not found. Downloading and installing to: ""$binpath"" ...`n" -ForegroundColor "Yellow"
			DownloadYoutube-dl
		}
	}
	
	if ($drrayTempRun -eq "1") {
		if (!(test-path -path "$tmpbinpath\ffmpeg.exe")) {
			Write-Host "`nffmpeg dependencies not found. Downloading and installing to: ""$tmpbinpath"" ...`n" -ForegroundColor "Yellow"
			DownloadTEMPFFmpeg
		}
	} elseif ($drrayTempRun -eq "0") {
		if (!(test-path -path "$binpath\ffmpeg.exe")) {
			Write-Host "`nffmpeg dependencies not found. Downloading and installing to: ""$binpath"" ...`n" -ForegroundColor "Yellow"
			DownloadFFmpeg
		}
	}

	Set-Location -Path "C:\Program Files (x86)\Dr. Ray Downloader" -ErrorAction SilentlyContinue
	Write-Progress -Activity "Starting Dr. Ray Downloader" -Status "Loading Dr. Ray Downloader . . ." -Completed

	Do {
		Write-Host ""
		Write-Host ""
		Write-Host "                              DR. RAY DOWNLOADER v3.3"
		Write-Host "                                      _____  "
		Write-Host "                                     ( o o ) "
		Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
		Write-Host "                               WHATCHA      WANT               "
		Write-Host " --------------------------------------------------------------------------------"
		Write-Host "      1.   DOWNLOAD AUDIO"
		Write-Host "      2.   DOWNLOAD VIDEO"
		Write-Host "      3.   UPDATE PROGRAM"
		Write-Host "      4.   HELP"
		Write-Host "      5.   EXIT"
		Write-Host " --------------------------------------------------------------------------------"
		Write-Host ""
		Write-Host ""
		$input = Read-Host "     Execute Command "
		Write-Host ""
		Write-Host ""

		switch ($input) {
			1 {
					audioRun
				}
			2 {
					videoRun
				}
			3 {
					drrayUpdate
				}
			4 {
					drrayHelp
				}
			5 {
					drrayExit
				}
		}
	} Until ($input -eq 5)
}

mainRun