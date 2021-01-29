### Dr. Downloader v3.0
### January 28th, 2021
### Script created by Raymond Mayer


# ======================================================================================================= #
# ======================================================================================================= #
#
# VARIABLES
#
# ======================================================================================================= #


Write-Progress -Activity "Starting Dr. Ray Downloader" -Status "Initializing variables . . ." -PercentComplete 10
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
[Version]$RunningVersion = '3.0.0.0'
$binpath = "C:\Program Files (x86)\Dr. Downloader\bin"
$downloadlocation = "C:\ProgramData\Dr. Downloader\Dr. Downloads"
$tmpfolder = "C:\temp"
$RootFolder = "$PSScriptRoot"
$ENV:Path += ";$binpath"
$StartFolder = $ENV:APPDATA + "\Microsoft\Windows\Start Menu\Programs\Dr. Downloader"


# ======================================================================================================= #
# ======================================================================================================= #
#
# FUNCTIONS
#
# ======================================================================================================= #


Function DownloadFile {
	Param(
		[String]$url,
		[String]$dest
	)
	(New-Object System.Net.WebClient).DownloadFile("$url", "$dest")
}


Function DownloadYoutube-dl {
	Write-Host ""
	Write-Host "Downloading youtube-dl binary . . ." -ForegroundColor "Yellow"
	Write-Host ""
	DownloadFile "http://yt-dl.org/downloads/latest/youtube-dl.exe" "$binpath\dl.exe"
}


Function DownloadFFmpeg {
	Write-Host ""
	Write-Host "Downloading ffmpeg files . . ." -ForegroundColor "Yellow"
	Write-Host ""
	DownloadFile "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z" "$binpath\ffmpeg_latest.7z"
	Write-Host ""
	Write-Host "Expanding ffmpeg 7-Zip archive . . ." -ForegroundColor "Yellow"
	Write-Host ""
#	Expand-Archive -Path "$binpath\ffmpeg_latest.7z" -DestinationPath "$binpath"
	Expand-7Zip -ArchiveFileName "$binpath\ffmpeg_latest.7z" -TargetPath "$binpath"
	Copy-Item -Path "$binpath\ffmpeg-*\bin\*" -Destination "$binpath" -Recurse -Filter "*.exe" -Force -ErrorAction SilentlyContinue
	Remove-Item -Path "$binpath\ffmpeg_latest.7z" -Force -ErrorAction SilentlyContinue
	Remove-Item -Path "$binpath\ffmpeg-*" -Recurse -Force -ErrorAction SilentlyContinue
}


Function UpdateScript {
	DownloadFile "https://raw.githubusercontent.com/dr-raypc/dr-downloader/main/bin/drray-version" "$tmpfolder\version-file.txt"
	[Version]$NewestVersion = Get-Content "$tmpfolder\version-file.txt" | Select -Index 0
	Remove-Item -Path "$tmpfolder\version-file.txt" -Force
	
	If ($NewestVersion -gt $RunningVersion) {
		Write-Host "`nA new version of Dr. Ray Downloader is available: v$NewestVersion" -ForegroundColor "Yellow"
		$MenuOption = Read-Host "`nUpdate to this version? [y/n]" -ForegroundColor "Yellow"
		
		If ($MenuOption -like "y" -or $MenuOption -like "yes") {
			DownloadFile "https://raw.githubusercontent.com/dr-raypc/dr-downloader/main/dr-downloader.ps1" "C:\Program Files (x86)\Dr. Downloader\dr-downloader.ps1"
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
	Write-Host "                              DR. RAY DOWNLOADER v3.0 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               DR. RAY     UPDATER          "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	Write-Host "`nUpdating youtube-dl and ffmpeg files . . ." -ForegroundColor "Yellow"
	DownloadYoutube-dl
	DownloadFfmpeg
	Write-Host "`nUpdate completed successfully." -ForegroundColor "Green"
	Start-Sleep 3
	Write-Host "`nChecking for Dr. Ray updates . . . " -ForegroundColor "Yellow"
	UpdateScript
	Write-Host "`nUpdate completed successfully." -ForegroundColor "Green"
	mainRun
}


function drrayInstallCheck {
	if (!(Test-path -Path "C:\Program Files (x86)\Dr. Downloader")) {
		Write-Host ""
		Write-Host "[ERROR]: Dr. Ray Downloader is not installed. Would you like to install it?" -ForegroundColor "Red" -BackgroundColor "Black"
		Write-Host ""
		$installdrray = (Read-Host "Y/N")
		if ($installdrray -like "y" -or $installdrray -like "yes") {
			drrayInstall
		} else {
			Write-Host ""
			Write-Host "[ERROR]: Missing dependencies. Please install Dr. Ray Downloader to continue." -ForegroundColor "Red" -BackgroundColor "Black"
			Write-Host ""
			exit 1
		}
	}
}


function drrayInstall {
	Write-Progress -Activity "Installing Dr. Ray Downloader" -Status "Installing . . ." -PercentComplete 40
	Write-Host ""
	Write-Host "Installing Dr. Ray Downloader . . ." -ForegroundColor "Yellow"
	Write-Host ""
	New-Item -ItemType Directory -Path "C:\ProgramData\Dr. Downloader" -Force -ErrorAction SilentlyContinue | out-null
	New-Item -ItemType Directory -Path "C:\ProgramData\Dr. Downloader\Dr. Downloads" -Force -ErrorAction SilentlyContinue | out-null
	Write-Progress -Activity "Installing Dr. Ray Downloader" -Status "Installing . . ." -PercentComplete 50
	New-Item -ItemType Directory -Path "C:\Program Files (x86)\Dr. Downloader" -Force -ErrorAction SilentlyContinue | out-null
	New-Item -ItemType Directory -Path "C:\Program Files (x86)\Dr. Downloader\bin" -Force -ErrorAction SilentlyContinue | out-null
	New-Item -ItemType Directory -Path "$StartFolder" -Force -ErrorAction SilentlyContinue | Out-Null
	Write-Progress -Activity "Installing Dr. Ray Downloader" -Status "Installing . . ." -PercentComplete 60
	$WshShell = New-Object -comObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut("$home\Desktop\Dr. Downloads.lnk")
	$shortcut.TargetPath = "C:\ProgramData\Dr. Downloader\Dr. Downloads"
	$shortcut.save()
	Write-Progress -Activity "Installing Dr. Ray Downloader" -Status "Installing . . ." -PercentComplete 80
	Add-MpPreference -ExclusionPath "C:\Program Files (x86)\Dr. Downloader" -Force
	
	TRY {
		Copy-Item "$PSScriptRoot\dr-downloader.ps1" -Destination "C:\Program Files (x86)\Dr. Downloader" -Force
	} CATCH {
		DownloadFile "https://raw.githubusercontent.com/dr-raypc/dr-downloader/main/dr-downloader.ps1" "C:\Program Files (x86)\Dr. Downloader\dr-downloader.ps1"
	} FINALLY {
		DownloadFFmpeg
		DownloadYoutube-dl
	}
	Write-Progress -Activity "Installing Dr. Ray Downloader" -Status "Installing . . ." -Completed
}


function audioRun {
	Write-Host ""
	Write-Host "                              DR. RAY DOWNLOADER v3.0 "
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
	Write-Host "                              DR. RAY DOWNLOADER v3.0 "
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
	Write-Host "                              DR. RAY DOWNLOADER v3.0 "
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
	Write-Host "              **When you are done, please exit using the #5 option**"
	Write-Host ""
	Write-Host ""
	Read-Host "               Press enter to return to the main menu  "
}


function drrayExit {
	Start-Process $downloadlocation
	exit 0
}


# ======================================================================================================= #
# ======================================================================================================= #
#
# MAIN FUNCTION
#
# ======================================================================================================= #


function mainRun {
	
#	if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
# 		 $arguments = "& '" +$myinvocation.mycommand.definition + "'"
#  	Start-Process powershell -Verb runAs -ArgumentList $arguments
#  	Break
#	}

	Write-Progress -Activity "Starting Dr. Ray Downloader" -Status "Checking main files . . ." -PercentComplete 20

	if (!(test-path -path "C:\Program Files (x86)\Dr. Downloader\*")) {
		drrayInstallCheck
	}
	
	If (([environment]::Is64BitOperatingSystem) -eq $false) {
		Write-Host "[ERROR]: Dr. Ray Downloader only supports 64 bit Operating Systems." -ForegroundColor "Red" -BackgroundColor "Black"
		End
	}

	If ($PSVersionTable.PSVersion.Major -lt 5) {
		Write-Host "[ERROR]: Your PowerShell installation is not version 5.0 or greater.`n        This script requires PowerShell version 5.0 or greater to function.`n        You can download PowerShell version 5.0 at:`n            https://www.microsoft.com/en-us/download/details.aspx?id=50395" -ForegroundColor "Red" -BackgroundColor "Black"
		Start-Sleep 10
		End
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
			https://www.microsoft.com/en-US/download/details.aspx?id=5555" -ForegroundColor "Red"  -BackgroundColor "Black"
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
		Write-Host "https://www.microsoft.com/en-US/download/details.aspx?id=5555" -ForegroundColor "Red"
	}
	
	Write-Progress -Activity "Starting Dr. Ray Downloader" -Status "Loading Dr. Ray Downloader . . ." -PercentComplete 90
	
	if (!(Test-Path -Path $downloadlocation)) {
		New-Item -ItemType Directory -Path $downloadlocation -Force -ErrorAction SilentlyContinue | Out-Null
	}
	
	if (!(test-path -path $tmpfolder)) {
		New-Item -ItemType Directory -Path $tmpfolder -Force -ErrorAction SilentlyContinue | Out-Null
	}
	
	If (!(test-path -path "$binpath\dl.exe")) {
		Write-Host "`nYouTube-dl not found. Downloading and installing to: ""$binpath"" ...`n" -ForegroundColor "Yellow"
		DownloadYoutube-dl
	}
	
	if (!(test-path -path "$binpath\ffmpeg.exe")) {
		Write-Host "`nffmpeg dependencies not found. Downloading and installing to: ""$binpath"" ...`n" -ForegroundColor "Yellow"
		DownloadFFmpeg
	}

	Set-Location -Path "C:\Program Files (x86)\Dr. Downloader" -ErrorAction SilentlyContinue

	Write-Progress -Activity "Starting Dr. Ray Downloader" -Status "Loading Dr. Ray Downloader . . ." -Completed

	Do {
		Write-Host ""
		Write-Host "                              DR. RAY DOWNLOADER v3.0 "
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