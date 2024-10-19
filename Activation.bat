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

:: Detect the Windows version automatically
for /f "tokens=4-5 delims=[.] " %%i in ('ver') do set version=%%i.%%j

echo Detected Windows version: %version%

:: Allow user to choose between automatic or manual edition detection
echo Do you want to:
echo 1. Automatically detect the edition
echo 2. Manually select the edition
set /p mode="Enter your choice (1 for automatic, 2 for manual): "

if "%mode%"=="1" (
    :: Automatic detection of Windows edition
    echo Detecting your Windows edition automatically...
    wmic os get caption | findstr /i "Home" > nul && set edition=Home
    wmic os get caption | findstr /i "Professional" > nul && set edition=Professional
    wmic os get caption | findstr /i "Enterprise" > nul && set edition=Enterprise
    wmic os get caption | findstr /i "Ultimate" > nul && set edition=Ultimate
    wmic os get caption | findstr /i "Education" > nul && set edition=Education
    wmic os get caption | findstr /i "Single Language" > nul && set edition=HomeSingleLanguage
    wmic os get caption | findstr /i "Country Specific" > nul && set edition=HomeCountrySpecific
    wmic os get caption | findstr /i "N" > nul && set edition=%edition%N

    if not defined edition (
        echo Could not automatically detect your Windows edition. Please run the script again and choose manual selection.
        pause
        exit /b
    )

    echo Detected Windows edition: %edition%
) else if "%mode%"=="2" (
    :: Manual selection of Windows edition
    if "%version%"=="6.1" (
        echo Windows 7 detected
        echo Choose your Windows 7 edition:
        echo 1. Home Premium
        echo 2. Home Basic
        echo 3. Professional
        echo 4. Ultimate
        set /p editionChoice="Enter the number corresponding to your Windows 7 edition: "
        
        if "%editionChoice%"=="1" set edition=HomePremium
        if "%editionChoice%"=="2" set edition=HomeBasic
        if "%editionChoice%"=="3" set edition=Professional
        if "%editionChoice%"=="4" set edition=Ultimate

    ) else if "%version%"=="6.3" (
        echo Windows 8.1 detected
        echo Choose your Windows 8.1 edition:
        echo 1. Core
        echo 2. Core N
        echo 3. Professional
        echo 4. Professional N
        set /p editionChoice="Enter the number corresponding to your Windows 8.1 edition: "

        if "%editionChoice%"=="1" set edition=Core
        if "%editionChoice%"=="2" set edition=CoreN
        if "%editionChoice%"=="3" set edition=Professional
        if "%editionChoice%"=="4" set edition=ProfessionalN

    ) else if "%version%"=="10.0" (
        echo Windows 10 detected
        echo Choose your Windows 10 edition:
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
        set /p editionChoice="Enter the number corresponding to your Windows 10 edition: "

        if "%editionChoice%"=="1" set edition=Home
        if "%editionChoice%"=="2" set edition=HomeN
        if "%editionChoice%"=="3" set edition=HomeSingleLanguage
        if "%editionChoice%"=="4" set edition=HomeCountrySpecific
        if "%editionChoice%"=="5" set edition=Professional
        if "%editionChoice%"=="6" set edition=ProfessionalN
        if "%editionChoice%"=="7" set edition=Education
        if "%editionChoice%"=="8" set edition=EducationN
        if "%editionChoice%"=="9" set edition=Enterprise
        if "%editionChoice%"=="10" set edition=EnterpriseN
    ) else (
        echo Unsupported Windows version: %version%
        pause
        exit /b
    )
) else (
    echo Invalid option. Please run the script again and choose a valid option.
    pause
    exit /b
)

:: Assign product keys based on edition and version
if "%version%"=="6.1" (
    if "%edition%"=="HomePremium" set key=6F4BT-BCFHX-DY8DH-KDHPY-TP7HT
    if "%edition%"=="HomeBasic" set key=YGFVB-QTFXQ-3H233-PTWTJ-YRYRV
    if "%edition%"=="Professional" set key=FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4
    if "%edition%"=="Ultimate" set key=342DG-6YJR8-X92GV-V7DCV-P4K27
) else if "%version%"=="6.3" (
    if "%edition%"=="Core" set key=MX3RK-9HNGX-K3QKC-6PJ3F-W8D7B
    if "%edition%"=="CoreN" set key=3NG3P-6C4G6-4JCVK-8GF4J-YVPPB
    if "%edition%"=="Professional" set key=GCRJD-8NW9H-F2CDX-CCM8D-9D6T9
    if "%edition%"=="ProfessionalN" set key=HN4F4-QBND8-R8P7F-RPJJH-KM6B4
) else if "%version%"=="10.0" (
    if "%edition%"=="Home" set key=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
    if "%edition%"=="HomeN" set key=3KHY7-WNT83-DGQKR-F7HPR-844BM
    if "%edition%"=="HomeSingleLanguage" set key=7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
    if "%edition%"=="HomeCountrySpecific" set key=PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
    if "%edition%"=="Professional" set key=W269N-WFGWX-YVC9B-4J6C9-T83GX
    if "%edition%"=="ProfessionalN" set key=MH37W-N47XK-V7XM9-C7227-GCQG9
    if "%edition%"=="Education" set key=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
    if "%edition%"=="EducationN" set key=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
    if "%edition%"=="Enterprise" set key=NPPR9-FWDCX-D2C8J-H872K-2YT43
    if "%edition%"=="EnterpriseN" set key=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
)

:: Preconfigured KMS server
set kmsServer=kms8.msguides.com

:: Install the product key
echo Installing product key %key%...
slmgr /ipk %key%

:: Configure the KMS server
echo Configuring KMS server: %kmsServer%
slmgr /skms %kmsServer%

:: Activate Windows
echo Activating Windows...
slmgr /ato

echo Activation complete!
pause
exit
