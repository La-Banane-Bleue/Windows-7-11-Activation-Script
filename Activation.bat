@echo off
:: This script must be run as an administrator
echo Must be run as admin!

:: Check if the user is an administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo You must run this script as an administrator.
    pause
    exit /b
)

:: Ask the user to choose their Windows version
echo Select your Windows version:
echo 1. Home
echo 2. Home N
echo 3. Home Single Language
echo 4. Home Country Specific
echo 5. Professional
echo 6. Professional N
echo 7. Education
echo 8. Education N
echo 9. Enterprise
echo 10. Enterprise N

set /p version="Enter the number corresponding to your Windows version: "

:: Assign the product key based on the selected version
if "%version%"=="1" set key=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
if "%version%"=="2" set key=3KHY7-WNT83-DGQKR-F7HPR-844BM
if "%version%"=="3" set key=7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
if "%version%"=="4" set key=PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
if "%version%"=="5" set key=W269N-WFGWX-YVC9B-4J6C9-T83GX
if "%version%"=="6" set key=MH37W-N47XK-V7XM9-C7227-GCQG9
if "%version%"=="7" set key=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
if "%version%"=="8" set key=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
if "%version%"=="9" set key=NPPR9-FWDCX-D2C8J-H872K-2YT43
if "%version%"=="10" set key=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4

:: Install the product key
echo Installing product key %key%...
slmgr /ipk %key%

:: Specify the organization's KMS server (replace "YourKMSServer" with the server's name or IP address)
set /p kmsServer="Enter your organization's KMS server address (or press Enter to skip): "

if not "%kmsServer%"=="" (
    echo Configuring KMS server: %kmsServer%
    slmgr /skms %kmsServer%
)

:: Activate Windows
echo Activating Windows...
slmgr /ato

echo Activation complete!
pause
exit
