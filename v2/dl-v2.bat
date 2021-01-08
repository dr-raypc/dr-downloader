@echo off

set binpath="%~dp0%\bin\"
set downloads="%USERPROFILE%\Desktop\New Downloads\"


if not exist "%USERPROFILE%\Desktop\New Downloads" MKDIR "%USERPROFILE%\Desktop\New Downloads" 1> nul
if not exist "%binpath%\DL.EXE" GOTO ERRMISSNG
if not exist "%binpath%\FFMPEG.EXE" GOTO ERRMISSNG
if not exist "%binpath%\FFPLAY.EXE" GOTO ERRMISSNG
if not exist "%binpath%\FFPROBE.EXE" GOTO ERRMISSNG


cd /d %binpath%








:MAIN
CLS
ECHO                             DR. RAY DOWNLOADER v2.0
ECHO                                      _____  
ECHO                                     ( o o )
ECHO --------------------------------oOOo-( _ )-oOOo---------------------------------
ECHO                               WHATCHA      WANT               
ECHO ================================================================================
ECHO 1.   YOUTUBE
ECHO 2.   SOUNDCLOUD
ECHO 3.   YOUTUBE2MP3
ECHO 4.   UPDATE PROGRAM
ECHO 5.   HELP
ECHO 6.   EXIT
ECHO ================================================================================

set /p number=Execute: 
set number=%number:~,10%
if "%number%"=="1" goto YTDWNLD
if "%number%"=="2" goto SCDWNLD
if "%number%"=="3" goto YTDWNLD2MP3
if "%number%"=="4" goto UPDTE
if "%number%"=="5" goto HLP
if "%number%"=="6" goto EXT
ECHO Invalid Number.
GOTO MAIN








:SCDWNLD
CLS
ECHO                             DR. RAY DOWNLOADER v2.0
ECHO                                      _____  
ECHO                                     ( o o )
ECHO --------------------------------oOOo-( _ )-oOOo---------------------------------
ECHO                          DR. RAY SOUNDCLOUD DOWNLOADER          
ECHO ================================================================================
ECHO.
set /p DLNK="DL LNK: "
echo.
echo.
if /I "%DLNK%" EQU "m" goto MAIN
if /I "%DLNK%" EQU "M" goto MAIN
dl.exe %DLNK% --output "%%(uploader)s - %%(title)s.%%(ext)s"
ROBOCOPY . "%USERPROFILE%\Desktop\New Downloads" *.mp3 /MOV /njh /nfl /njs /ndl /nc /ns
echo.
echo.
ECHO.
ECHO.
set /P rerun=Got another lnk? (Y/N)
if /I "%rerun%" EQU "y" goto SCDWNLD
if /I "%rerun%" EQU "Y" goto SCDWNLD
if /I "%rerun%" EQU "n" goto QSTN
if /I "%rerun%" EQU "N" goto QSTN








:YTDWNLD
CLS
ECHO                             DR. RAY DOWNLOADER v2.0
ECHO                                      _____  
ECHO                                     ( o o )
ECHO --------------------------------oOOo-( _ )-oOOo---------------------------------
ECHO                            DR. RAY YOUTUBE DOWNLOADER               
ECHO ================================================================================
ECHO.
set /p DLNK="DL LNK: "
echo.
echo.
if /I "%DLNK%" EQU "m" goto MAIN
if /I "%DLNK%" EQU "M" goto MAIN
dl %DLNK% --format "(bestvideo+bestaudio/best)" --output "%%(uploader)s - %%(title)s.%%(ext)s"
ROBOCOPY . "%USERPROFILE%\Desktop\New Downloads" *.mp3 /MOV /njh /nfl /njs /ndl /nc /ns
echo.
echo.
ECHO.
ECHO.
set /P rerun=Got another vid lnk? (Y/N)
if /I "%rerun%" EQU "y" goto YTDWNLD
if /I "%rerun%" EQU "Y" goto YTDWNLD
if /I "%rerun%" EQU "n" goto QSTN
if /I "%rerun%" EQU "N" goto QSTN








:YTDWNLD2MP3
CLS
ECHO                             DR. RAY DOWNLOADER v2.0
ECHO                                      _____  
ECHO                                     ( o o )
ECHO --------------------------------oOOo-( _ )-oOOo---------------------------------
ECHO                          DR. RAY YOUTUBE2MP3 DOWNLOADER             
ECHO ================================================================================
ECHO.
set /p DLNK="DL LNK: "
echo.
echo.
if /I "%DLNK%" EQU "m" goto MAIN
if /I "%DLNK%" EQU "M" goto MAIN
dl --format bestaudio -x --audio-format mp3 --audio-quality 0 %DLNK% --output "%%(title)s.%%(ext)s"
ROBOCOPY . "%USERPROFILE%\Desktop\New Downloads" *.mp3 /MOV /njh /nfl /njs /ndl /nc /ns
echo.
echo.
ECHO.
ECHO.
set /P rerun=Got another lnk? (Y/N)
if /I "%rerun%" EQU "y" goto YTDWNLD2MP3
if /I "%rerun%" EQU "Y" goto YTDWNLD2MP3
if /I "%rerun%" EQU "n" goto QSTN
if /I "%rerun%" EQU "N" goto QSTN








:HLP
CLS
ECHO                             DR. RAY DOWNLOADER v2.0
ECHO                                      _____  
ECHO                                     ( o o )
ECHO --------------------------------oOOo-( _ )-oOOo---------------------------------
ECHO                                 DR. RAY HELPER               
ECHO ================================================================================
ECHO.
ECHO  This small application will download the original file uploaded to SoundCloud
ECHO      or YouTube. Paste link by right clicking in the box. You may use any
ECHO          option, but the YTDWNLD option will download the best vid/aud
ECHO              that is available. If you are downloading a simple MP3
ECHO                    please use the SNDCLD option. When it says
ECHO                        DLNK you may type M at anytime to go
ECHO                             back to the MAIN menu. TY
ECHO.
ECHO.
ECHO              **When you are done please exit using the #6 option**
ECHO.
ECHO.
ECHO.
ECHO.
set /P rerun=EXIT? (Y/N)
if /I "%rerun%" EQU "y" goto EXT
if /I "%rerun%" EQU "Y" goto EXT
if /I "%rerun%" EQU "n" goto MAIN
if /I "%rerun%" EQU "N" goto MAIN








:UPDTE
CLS
ECHO                             DR. RAY DOWNLOADER v2.0
ECHO                                      _____  
ECHO                                     ( o o )
ECHO --------------------------------oOOo-( _ )-oOOo---------------------------------
ECHO                                DR. RAY - UPDATER               
ECHO ================================================================================
ECHO.
ECHO.
ECHO                     Updating core components...please be patient
ECHO.
ECHO.
ECHO         **Please only update this application if it is not working correctly**
ECHO.
ECHO.
ECHO.
ECHO.
timeout /t 3
START "" /b /wait "dl.exe" --update
timeout /t 5
GOTO UPDTEDONE








:UPDTEDONE
CLS
ECHO                             DR. RAY DOWNLOADER v2.0
ECHO                                      _____  
ECHO                                     ( o o )
ECHO --------------------------------oOOo-( _ )-oOOo---------------------------------
ECHO                                DR. RAY - UPDATER               
ECHO ================================================================================
ECHO.                  
ECHO.
ECHO.
ECHO                             UPDATED SUCCESSFULLY !
ECHO.
ECHO.
ECHO.
ECHO.
timeout /t 2
GOTO MAIN








:ERRMISSNG
CLS
ECHO                             DR. RAY DOWNLOADER v2.0
ECHO                                      _____  
ECHO                                     ( o o )
ECHO --------------------------------oOOo-( _ )-oOOo---------------------------------
ECHO                                DR. RAY - UPDATER               
ECHO ================================================================================
ECHO.
ECHO.
ECHO                   DR. RAY DOWNLOADER is missing its main components.
ECHO.
ECHO.
ECHO             Would you like to update the application to the latest version?
ECHO.
ECHO.
ECHO.
ECHO.
set /P rerun=UPDATE? (Y/N)
if /I "%rerun%" EQU "y" goto UPDTE
if /I "%rerun%" EQU "Y" goto UPDTE
if /I "%rerun%" EQU "n" goto MAIN
if /I "%rerun%" EQU "N" goto MAIN








:QSTN
CLS
ECHO                             DR. RAY DOWNLOADER v2.0
ECHO                                      _____  
ECHO                                     ( o o )
ECHO --------------------------------oOOo-( _ )-oOOo---------------------------------
ECHO ?                              DR. RAY - QUESTION                              ?
ECHO ================================================================================
ECHO.
set /P rerun=Wanna Quit? (Y/N)
if /I "%rerun%" EQU "n" goto MAIN
if /I "%rerun%" EQU "N" goto MAIN
if /I "%rerun%" EQU "y" goto EXT
if /I "%rerun%" EQU "Y" goto EXT








:EXT
%SystemRoot%\explorer.exe "%USERPROFILE%\Desktop\New Downloads"
EXIT
