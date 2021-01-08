### Dr. Downloader v3.0
### August 28th, 2020
### Script created by Raymond Mayer

$binpath = "C:\Program Files (x86)\Dr. Downloader\bin\"
$downloadpath = "$($env:USERPROFILE)\Desktop\New Downloads"

function youtubeRun {
	Clear-Host
	Write-Host ""
	Write-Host "                             DR. RAY DOWNLOADER v3.0 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               DR. RAY     YOUTUBE DOWNLOADER          "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	Write-Host ""
}

function soundcloudRun {
	Clear-Host
	Write-Host ""
	Write-Host "                             DR. RAY DOWNLOADER v3.0 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               DR. RAY     SOUNDCLOUD DOWNLOADER          "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	Write-Host ""
}

function  youtubeMP3Run {
	Clear-Host
	Write-Host ""
	Write-Host "                             DR. RAY DOWNLOADER v3.0 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               DR. RAY     YOUTUBE2MPL3 DOWNLOAER         "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	Write-Host ""
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
	Write-Host ""
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


function mainRun {
	#if (!(Test-Path -Path $downloadpath)) {
	#	New-Item -ItemType Directory -Path "$downloadpath" -Force -ErrorAction SilentlyContinue | Out-Null
	#}
	Do {

	Write-Host ""
	Write-Host "                             DR. RAY DOWNLOADER v3.0 "
	Write-Host "                                      _____  "
	Write-Host "                                     ( o o ) "
	Write-Host " --------------------------------oOOo-( _ )-oOOo--------------------------------- "
	Write-Host "                               WHATCHA      WANT               "
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host "      1.   YOUTUBE VIDEOS"
	Write-Host "      2.   SOUNDCLOUD"
	Write-Host "      3.   YOUTUBE 2 MP3"
	Write-Host "      4.   UPDATE PROGRAM"
	Write-Host "      5.   HELP"
	Write-Host "      6.   EXIT"
	Write-Host " --------------------------------------------------------------------------------"
	Write-Host ""
	Write-Host ""
	$input = Read-Host "     Execute Command: "
	Write-Host ""
	Write-Host ""

	switch ($input) {
		
		1 {
				youtubeRun
			}
		2 {
				soundcloudRun
			}
		3 {
				youtubeMP3Run
			}
		4 {
				drrayUpdate
			}
		5 {
				drrayHelp
			}
		6 {
				drrayExit
			}
		}
	} Until ($input -eq 6)
}
mainRun






