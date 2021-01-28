### Dr. Downloader v3.0
### August 28th, 2020
### Script created by Raymond Mayer

$binpath = "C:\Program Files (x86)\Dr. Downloader\bin"
$downloadlocation = "$($env:USERPROFILE)\Desktop\New Downloads"
$tmpfolder = "C:\temp"
$RootFolder = "$PSScriptRoot"
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"


Function DownloadFile {
	Param(
		[String]$url,
		[String]$dest
	)
	(New-Object System.Net.WebClient).DownloadFile("$url", "$dest")
}


Function DownloadYoutube-dl {
	DownloadFile "http://yt-dl.org/downloads/latest/youtube-dl.exe" "$binpath\dl.exe"
}


Function DownloadFFmpeg {
	If (([environment]::Is64BitOperatingSystem) -eq $True) {
		DownloadFile "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z" "$binpath\ffmpeg_latest.7z"
	}
	Else {
		DownloadFile "http://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.zip" "$binpath\ffmpeg_latest.zip"
	}
	Expand-Archive -Path "$binpath\ffmpeg_latest.7z" -DestinationPath "$binpath"
	Copy-Item -Path "$binpath\ffmpeg-*-win*-static\bin\*" -Destination "$binpath" -Recurse -Filter "*.exe" -Force -ErrorAction SilentlyContinue
	Remove-Item -Path "$binpath\ffmpeg_latest.7z" -Force -ErrorAction SilentlyContinue
	Remove-Item -Path "$binpath\ffmpeg-*-win*-static" -Recurse -Force -ErrorAction SilentlyContinue
}


Function UpdateScript {
	DownloadFile "https://raw.githubusercontent.com/dr-raypc/dr-downloader/main/bin/drray-version" "$tmpfolder\version-file.txt"
	[Version]$NewestVersion = Get-Content "$tmpfolder\version-file.txt" | Select -Index 0
	Remove-Item -Path "$tmpfolder\version-file.txt" -Force
	
	If ($NewestVersion -gt $RunningVersion) {
		Write-Host "`nA new version of Dr. Ray Downloader is available: v$NewestVersion" -ForegroundColor "Yellow"
		$MenuOption = Read-Host "`nUpdate to this version? [y/n]" -ForegroundColor "Yellow"
		
		If ($MenuOption -like "y" -or $MenuOption -like "yes") {
			DownloadFile "https://raw.githubusercontent.com/dr-raypc/dr-downloader/main/v3/dr-downloader-v3.ps1" "$RootFolder\dr-downloader-v3.ps1"
		}
			Write-Host "`nUpdate complete. Please restart the script." -ForegroundColor "Green"
			Start-Sleep 3
			Exit
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


function audioRun {
	Clear-Host
	Write-Host ""
	Write-Host "                             DR. RAY DOWNLOADER v3.0 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               DR. RAY     AUDIO DOWNLOADER          "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	$audioURL = (Read-Host "URL").Trim()
	Write-Host ""
	Write-Host ""
	Write-Host "`nDownloading video from: $audioURL`n"
	$audioDWNLD = "dl -o ""$downloadlocation\%(title)s.%(ext)s"" --format bestaudio -x --audio-format mp3 --audio-quality 0 --ignore-errors --console-title --no-mtime ""$audioURL"""
	Invoke-Expression "$audioDWNLD"
}


function  videoRun {
	Clear-Host
	Write-Host ""
	Write-Host "                             DR. RAY DOWNLOADER v3.0 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               DR. RAY     VIDEO DOWNLOAER         "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	$videoURL = (Read-Host "URL").Trim()
	Write-Host ""
	Write-Host ""
	Write-Host "`nDownloading video from: $videoURL`n"
	$videoDWNLD = "dl -o ""$downloadlocation\%(title)s.%(ext)s"" --ignore-errors --console-title --no-mtime ""$videoURL"""
	Invoke-Expression "$videoDWNLD"
}


function drrayUpdate {
	Clear-Host
	Write-Host ""
	Write-Host "                             DR. RAY DOWNLOADER v3.0 "
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


function drrayHelp {
	Clear-Host
	Write-Host ""
	Write-Host "                             DR. RAY DOWNLOADER v3.0 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               DR. RAY     HELPER          "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	Write-Host "   Dr. Ray Downloader (or Dr. Downloader) is a small. lightweight application"
	Write-Host "     coded in PowerShell that operates the youtube-dl command line. This"
	Write-Host "       application allows any user to download audio or video from media"
	Write-Host "        websites such as YouTube, SoundCloud, LiveLeak, etc."
	Write-Host ""
	Write-Host "              **When you are done, please exit using the #5 option**"
	Write-Host ""
	Write-Host ""
	Read-Host "               Press any key to return to the main menu     "
}

function drrayExit {
	Start-Process -Path "$($env:USERPROFILE)\Desktop\New Downloads"
	exit 0
}


# ======================================================================================================= #
# ======================================================================================================= #
#
# MAIN
#
# ======================================================================================================= #


function mainRun {
	[Version]$RunningVersion = '3.0.0.0'
	$ENV:Path += ";$binpath"

	If ($PSVersionTable.PSVersion.Major -lt 5) {
		Write-Host "[ERROR]: Your PowerShell installation is not version 5.0 or greater.`n        This script requires PowerShell version 5.0 or greater to function.`n        You can download PowerShell version 5.0 at:`n            https://www.microsoft.com/en-us/download/details.aspx?id=50395" -ForegroundColor "Red" -BackgroundColor "Black"
		Start-Sleep 10
		End
	}
	
	if (-not(Get-InstalledModule 7Zip4PowerShell -ErrorAction SilentlyContinue)) {
		Set-PSRepository PSGallery -InstallationPolicy Trusted
		Install-Module -Name 7Zip4PowerShell -Confirm:$false -Force
	}
	
	Try {
		$MSVISREDIST = Get-WmiObject -class win32_product -Filter {Name like "%Microsoft Visual C++ 2010  x86 Redistributable%"} | select Name
		if (-not($MSVISREDIST -contains "*Microsoft Visual C++ 2010  x86 Redistributable*")) {
			Write-Host "[ERROR]: Microsoft Visual C++ 2010 x86 Redistributable package must be installed. It can be downloaded here:`n
			https://www.microsoft.com/en-US/download/details.aspx?id=5555" -ForegroundColor "Red"  -BackgroundColor "Black"
			Write-Host ""
			$msvisredistdownload = Read-Host "Should we download and install the Microsoft Visual C++ 2010 x86 Redistributable package?"
			if ($msvisredistdownload -like "y" -or $msvisredistdownload -like "yes") {
				DownloadFile "https://github.com/dr-raypc/dr-downloader/blob/main/bin/vcredist_x86.exe?raw=true" "$tmpfolder\vcredist_x86.exe"
				Start-Process "$tmpfolder\vcredist_x86.exe" -Force
				exit
			}
		}
	} Catch {
		Write-Host "[ERROR]: Microsoft Visual C++ 2010 x86 Redistributable package must be installed. It can be downloaded here:" -ForegroundColor "Red"
		Write-Host "https://www.microsoft.com/en-US/download/details.aspx?id=5555" -ForegroundColor "Red"
	}
	
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


	Do {
		Write-Host ""
		Write-Host "                             DR. RAY DOWNLOADER v3.0 "
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
		$input = Read-Host "     Execute Command: "
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






