Param(
[Parameter(Mandatory=$true)]
[ValidateSet("Install", "Uninstall")]
[String[]]
$Mode
)
# Author: Warren Sherwen
# Verison: 1.0

# Defines the log file location.
$Logfile = "$env:windir\Temp\Logs\lockscreenandbackground.log"

# LogWrite Function.
Function LogWrite{
   Param ([string]$logstring)
   Add-content $Logfile -value $logstring
   write-output $logstring
}

function Get-TimeStamp {
	return "[{0:dd/MM/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

if (!(Test-Path "$env:windir\Temp\Logs\"))
	{
	   mkdir $env:windir\Temp\Logs
	   LogWrite "$(Get-TimeStamp): Lockscreen and Backgruoud script has started."
	   LogWrite "$(Get-TimeStamp): Log directory created."
	}
	else
	{
		LogWrite "$(Get-TimeStamp): Lockscreen and Backgruoud script has started."
		LogWrite "$(Get-TimeStamp): Log directory exists."
	}

if (!(Test-Path "$Env:SystemDrive\Background"))
	{
       LogWrite "$(Get-TimeStamp): Creating background folder."
       mkdir $Env:SystemDrive\Background
       LogWrite "$(Get-TimeStamp): Background folder created."
	}
	else
	{
        LogWrite "$(Get-TimeStamp): Background folder already exists."
	}


#Registry key paths
$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"

$DesktopImagePath = "DesktopImagePath"
$DesktopImageStatus = "DesktopImageStatus"
$DesktopImageUrl = "DesktopImageUrl"


$LockScreenImagePath = "LockScreenImagePath"
$LockScreenImageStatus = "LockScreenImageStatus"
$LockScreenImageUrl = "LockScreenImageUrl"

#Status value for enforcing background and lockscreen.
$StatusValue = "1"

####################################### ---- Amendendable Variables ---- #######################################

#Where your saved files in the assets folder may differ from background or lockscreen.
$BackgroundImage = "Background.jpg"
$LockscreenImage = "Lockscreen.jpg"

# The below file names, only need amending where you plan to have diffrent types of images per user/device type. I.e. several deployed applications.
$NewBackgroundName = "Background.jpg"
$NewLockScreenName = "Lockscreen.jpg"

####################################### ---- Amendendable Variables ---- #######################################

$DesktopBackgroundLocalFile = "$Env:SystemDrive\Background\$NewBackgroundName"
$LockscreenBackgroundLocalFile = "$Env:SystemDrive\Background\$NewLockScreenName"

	If ($Mode -eq "Install") {
        if (!$LockscreenImage -and !$BackgroundImage){
            LogWrite "$(Get-TimeStamp): You must have either a Lockscreen or Wallpaper image defined, witin the assets folder."
            LogWrite "$(Get-TimeStamp): Setup is exiting."
            Exit
        }
        else{
            if(!(Test-Path $RegistryKeyPath)){
                LogWrite "$(Get-TimeStamp):Creating registry path: $($RegistryKeyPath)."
                New-Item -Path $RegistryKeyPath -Force
            }

            if ($LockscreenImage){
                LogWrite "$(Get-TimeStamp): Copy lockscreen ""$($LockscreenImage)"" to ""$($LockscreenBackgroundLocalFile)"""
                Copy-Item ".\Assets\$LockscreenImage" $LockscreenBackgroundLocalFile -Force
                LogWrite "$(Get-TimeStamp):Creating regkeys for lockscreen"
                New-ItemProperty -Path $RegistryKeyPath -Name $LockScreenImageStatus -Value $StatusValue -PropertyType DWORD -Force
                New-ItemProperty -Path $RegistryKeyPath -Name $LockScreenImagePath -Value $LockscreenBackgroundLocalFile -PropertyType STRING -Force
                New-ItemProperty -Path $RegistryKeyPath -Name $LockScreenImageUrl -Value $LockscreenBackgroundLocalFile -PropertyType STRING -Force
                LogWrite "$(Get-TimeStamp): Registry files created"
            }

            if ($BackgroundImage){
                LogWrite "$(Get-TimeStamp): Copy wallpaper ""$($BackgroundImage)"" to ""$($DesktopBackgroundLocalFile)"""
                Copy-Item ".\Assets\$BackgroundImage" $DesktopBackgroundLocalFile -Force
                LogWrite "$(Get-TimeStamp):Creating regkeys for wallpaper"
                New-ItemProperty -Path $RegistryKeyPath -Name $DesktopImageStatus -value $StatusValue -PropertyType DWORD -Force
                New-ItemProperty -Path $RegistryKeyPath -Name $DesktopImagePath -value $DesktopBackgroundLocalFile -PropertyType STRING -Force
                New-ItemProperty -Path $RegistryKeyPath -Name $DesktopImageUrl -value $DesktopBackgroundLocalFile -PropertyType STRING -Force
                LogWrite "$(Get-TimeStamp): Registry files created"
            }  
        }
        LogWrite "$(Get-TimeStamp): Requesting soft reboot and exit"
        Exit 3010
    }

	If ($Mode -eq "Uninstall") {
        LogWrite "$(Get-TimeStamp):Deleting the images"
        Remove-Item "$Env:SystemDrive\Background\$NewBackgroundName\$NewBackgroundName" -Force -ErrorAction SilentlyContinue
        Remove-Item "$Env:SystemDrive\Background\$NewBackgroundName\$NewLockScreenName" -Force -ErrorAction SilentlyContinue
        LogWrite "$(Get-TimeStamp): Images Deleted"

        LogWrite "$(Get-TimeStamp): Deleting registry entries"
        Remove-ItemProperty -Path $RegistryKeyPath -Name $LockScreenImageStatus -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $RegistryKeyPath -Name $LockScreenImagePath -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $RegistryKeyPath -Name $LockScreenImageUrl -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $RegistryKeyPath -Name $DesktopImageStatus -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $RegistryKeyPath -Name $DesktopImagePath -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path $RegistryKeyPath -Name $DesktopImageUrl -Force  -ErrorAction SilentlyContinue
        LogWrite "$(Get-TimeStamp): Registry entries deleted"
        LogWrite "$(Get-TimeStamp): Requesting soft reboot and exit"
        Exit 3010
    }