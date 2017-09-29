if not exist "c:\ProgramData\chocoportable" goto doit
goto cancel

:doit
    echo perform Chocolatey installation
    goto exit
    
	:: Install Chocolatey Package Manager for Windows
	
	:: Set directory for installation - Chocolatey does not lock 
	:: down the directory if not the default
	SET INSTALLDIR=c:\ProgramData\chocoportable
	setx ChocolateyInstall %INSTALLDIR%
	
	:: All install options - offline, proxy, etc at
	:: https://chocolatey.org/install
	@powershell -NoProfile -ExecutionPolicy Bypass -Command "(iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))) >$null 2>&1" && SET PATH="%PATH%;%INSTALLDIR%\bin"

:cancel
    echo Chocolatey is already installed.
    goto choco
	
:choco
	CALL choco install puppet-agent.portable -y
	CALL choco install ruby.portable -y
	CALL choco install git.commandline -y
	CALL choco upgrade chocolatey
	
	:: Install Nodejs
	CALL choco install node -y
	
	goto appium

:appium
	:: Install Appium and dependencies via npm
	CALL npm install -g appium
	CALL npm install -g appium-doctor
	CALL npm install wd
	CALL npm install -g ios-deploy
	CALL gem install xcpretty 

:inspector
	:: Install Macaca Mobile Inspector
	CALL npm install macaca-cli -g
	CALL macaca doctor
	CALL npm install app-inspector -g
	goto exit

:exit
    echo script is finished.