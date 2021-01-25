### Dr. Downloader v3.0
### August 28th, 2020
### Script created by Raymond Mayer

$binpath = "C:\Program Files (x86)\Dr. Downloader\bin"
$downloadlocation = "$($env:USERPROFILE)\Desktop\New Downloads"
$tmpfolder = "C:\Program Files (x86)\Dr. Downloader\temp"
$RootFolder = "$PSScriptRoot"

Function DownloadFile {
	Param(
		[String]$URLToDownload,
		[String]$SaveLocation
	)
	(New-Object System.Net.WebClient).DownloadFile("$URLToDownload", "$tmpfolder")
}


Function DownloadYoutube-dl {
	DownloadFile "http://yt-dl.org/downloads/latest/youtube-dl.exe" "$binpath\dl.exe"
}


Function DownloadFFmpeg {
	If (([environment]::Is64BitOperatingSystem) -eq $True) {
		DownloadFile "http://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-latest-win64-static.zip" "$binpath\ffmpeg_latest.zip"
	}
	Else {
		DownloadFile "http://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.zip" "$binpath\ffmpeg_latest.zip"
	}
	Expand-Archive -Path "$binpath\ffmpeg_latest.zip" -DestinationPath "$binpath"
	Copy-Item -Path "$binpath\ffmpeg-*-win*-static\bin\*" -Destination "$binpath" -Recurse -Filter "*.exe" -Force -ErrorAction Silent 
	Remove-Item -Path "$binpath\ffmpeg_latest.zip" -Force
	Remove-Item -Path "$binpath\ffmpeg-*-win*-static" -Recurse -Force
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


Function UpdateScript {
	DownloadFile "https://github.com/dr-raypc/dr-downloader/blob/main/bin/drray-version" "$tmpfolder\version-file.txt"
	[Version]$NewestVersion = Get-Content "$tmpfolder\version-file.txt" | Select -Index 0
	Remove-Item -Path "$tmpfolder\version-file.txt"
	
	If ($NewestVersion -gt $RunningVersion) {
		Write-Host "`nA new version of Dr. Ray Downloader is available: v$NewestVersion" -ForegroundColor "Yellow"
		$MenuOption = Read-Host "`nUpdate to this version? [y/n]" -ForegroundColor "Yellow"
		
		If ($MenuOption -like "y" -or $MenuOption -like "yes") {
			DownloadFile "https://github.com/dr-raypc/dr-downloader/blob/main/v3/dr-downloader-v3.ps1" "$RootFolder\dr-downloader-v3.ps1"
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
	Write-Host "   This small application will download the original file uploaded to SoundCloud"
	Write-Host "      or YouTube. Paste link by right clicking in the box. You may use any"
	Write-Host "          option, but the YTDWNLD option will download the best vid/aud"
	Write-Host "              that is available. If you are downloading a simple MP3"
	Write-Host "                    please use the SNDCLD option. When it says"
	Write-Host "                        DLNK you may type M at anytime to go"
	Write-Host "                             back to the MAIN menu. TY"
	Write-Host ""
	Write-Host ""
	Write-Host "              **When you are done please exit using the #6 option**"
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
	[Version]$RunningVersion = '3.0.0'
	[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
	$ENV:Path += ";$binpath"

	If ($PSVersionTable.PSVersion.Major -lt 5) {
		Write-Host "[ERROR]: Your PowerShell installation is not version 5.0 or greater.`n        This script requires PowerShell version 5.0 or greater to function.`n        You can download PowerShell version 5.0 at:`n            https://www.microsoft.com/en-us/download/details.aspx?id=50395" -ForegroundColor "Red" -BackgroundColor "Black"
		Start-Sleep 10
		End
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






