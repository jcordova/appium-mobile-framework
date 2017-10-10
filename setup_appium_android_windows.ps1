# Run as Administrator
Function Check-RunAsAdministrator()
{
  #Get current user context
  $CurrentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  
  #Check user is running the script is member of Administrator Group
  if($CurrentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))
  {
       Write-host "Script is running with Administrator privileges!"
  }
  else
    {
       #Create a new Elevated process to Start PowerShell
       $ElevatedProcess = New-Object System.Diagnostics.ProcessStartInfo "PowerShell";
 
       # Specify the current script path and name as a parameter
       $ElevatedProcess.Arguments = "& '" + $script:MyInvocation.MyCommand.Path + "'"
 
       #Set the Process to elevated
       $ElevatedProcess.Verb = "runas"
 
       #Start the new elevated process
       [System.Diagnostics.Process]::Start($ElevatedProcess)
 
       #Exit from the current, unelevated, process
       Exit
 
    }
}
 
#Check Script is running with Elevated Privileges
Check-RunAsAdministrator
 
#Place your script here.
write-host "Welcome"


# ----------------------------------------------------------------------------------------------------------

# Check if Command or App exist Function
Function Test-CommandExists
{
    Param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'
    try 
    {
        if(Get-Command $command)
        {
            RETURN $true
        }
    }
    Catch 
    {
        Write-Host "$command does not exist"; 
        RETURN $false
    }
    Finally 
    {
        $ErrorActionPreference=$oldPreference
    }
} #end function test-CommandExists


# ----------------------------------------------------------------------------------------------------------


If(!(Test-CommandExists choco))
{
    # Installing Chocolatey

    # Set directory for installation - Chocolatey does not lock down the directory if not the default
    $InstallDir='C:\ProgramData\chocoportable'
    $env:ChocolateyInstall="$InstallDir"

    # If your PowerShell Execution policy is restrictive, you may not be able to get around that. 
    # Try setting your session to Bypass.
    Set-ExecutionPolicy Bypass

    # All install options - offline, proxy, etc at https://chocolatey.org/install
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    # PowerShell 3+?
    # iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
}

If(Test-CommandExists choco)
{
    choco upgrade chocolatey
    choco install puppet-agent -y
    choco install git -y
    choco install ruby -y
    choco install nodejs -y
}

If(Test-CommandExists gem)
{
    # Install Appium Ruby dependency
    gem install xcpretty 
}

If(Test-CommandExists node)
{
    # if node is installed
    # Install Appium and dependencies via npm
    npm install -g appium
    npm install -g appium-doctor
    npm install wd

    # if node npm is installed
    # Install Macaca Mobile Inspector 
    npm install macaca-cli -g
    macaca doctor
    npm install app-inspector -g
}