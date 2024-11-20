Param(
	[Parameter(Mandatory=$true)]
	[ValidateSet("Install", "Uninstall")]
	[String[]]
	$Mode
	)
	# Author: Warren Sherwen
	# Verison: 1.0

	# Defines the log file location.
	$Logfile = "$env:windir\Temp\Logs\companybranding.log"

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
	   LogWrite "$(Get-TimeStamp): Company Branding script has started."
	   LogWrite "$(Get-TimeStamp): Log directory created."
	}
	else
	{
		LogWrite "$(Get-TimeStamp): Company Branding script has started."
		LogWrite "$(Get-TimeStamp): Log directory exists."
	}

$WallpaperIMG = "Background.jpg"
$LockscreenIMG = "Lockscreen.jpg"

$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$BackgroundPath = "DesktopImagePath"
$BackgroundStatus = "DesktopImageStatus"
$DesktopUrl = "DesktopImageUrl"
$LockScreenPath = "LockScreenImagePath"
$LockScreenStatus = "LockScreenImageStatus"
$LockScreenUrl = "LockScreenImageUrl"
$StatusValue = "1"

$BackgroundLocation = "C:\Background\Desktop.jpg"
$LockscreenLocation = "C:\Background\Lockscreen.jpg"

If ($Mode -eq "Install") {
    if (!(Test-Path "c:\Background")) {
	   mkdir C:\Background -Force
       LogWrite "$(Get-TimeStamp): directory created."
	}
	else{
        LogWrite "$(Get-TimeStamp): Background directory exists."
	}

    New-Item -Path $RegistryKeyPath -Force -ErrorAction SilentlyContinue

    if (!$LockscreenIMG -and !$WallpaperIMG){
        LogWrite "$(Get-TimeStamp): Niether the lockscreen or background have values set."
    }
    else{

        if ($LockscreenIMG){
            LogWrite "$(Get-TimeStamp): Copying lockscreen ""$($LockscreenIMG)"" to ""$($LockscreenLocation)"""
            Copy-Item ".\Assets\$LockscreenIMG" $LockscreenLocation -Force
            LogWrite "$(Get-TimeStamp): Creating regkeys for lockscreen"
            New-ItemProperty -Path $RegistryKeyPath -Name $LockScreenStatus -Value $StatusValue -PropertyType DWORD -Force
            New-ItemProperty -Path $RegistryKeyPath -Name $LockScreenPath -Value $LockscreenLocation -PropertyType STRING -Force
            New-ItemProperty -Path $RegistryKeyPath -Name $LockScreenUrl -Value $LockscreenLocation -PropertyType STRING -Force
        }
        if ($WallpaperIMG){
            LogWrite "$(Get-TimeStamp): Copying wallpaper ""$($WallpaperIMG)"" to ""$($BackgroundLocation)"""
            Copy-Item ".\Assets\$WallpaperIMG" $BackgroundLocation -Force
            LogWrite "$(Get-TimeStamp): Creating regkeys for wallpaper"
            New-ItemProperty -Path $RegistryKeyPath -Name $BackgroundStatus -Value $StatusValue -PropertyType DWORD -Force
            New-ItemProperty -Path $RegistryKeyPath -Name $BackgroundPath -Value $BackgroundLocation -PropertyType STRING -Force
            New-ItemProperty -Path $RegistryKeyPath -Name $DesktopUrl -Value $BackgroundLocation -PropertyType STRING -Force
        }  
    }
    LogWrite "$(Get-TimeStamp): Script has been completed."
    exit
}

If ($Mode -eq "Uninstall") {
    if (!$LockscreenIMG -and !$WallpaperIMG){
    LogWrite "$(Get-TimeStamp): Niether the lockscreen or background have values set."
}
else{
        if ($LockscreenIMG){
            LogWrite "$(Get-TimeStamp): Removing the registry keys and file for the lockscreen"
            Remove-ItemProperty -Path $RegistryKeyPath -Name $LockScreenStatus -Force
            Remove-ItemProperty -Path $RegistryKeyPath -Name $LockScreenPath -Force
            Remove-ItemProperty -Path $RegistryKeyPath -Name $LockScreenUrl -Force
            Remove-Item $LockscreenLocation -Force
        }
        if ($WallpaperIMG){
            LogWrite "$(Get-TimeStamp): Removing the registry keys and file for the background"
            Remove-ItemProperty -Path $RegistryKeyPath -Name $BackgroundStatus -Force
            Remove-ItemProperty -Path $RegistryKeyPath -Name $BackgroundPath -Force
            Remove-ItemProperty -Path $RegistryKeyPath -Name $DesktopUrl -Force
            Remove-Item $BackgroundLocation -Force
        }  
    }
    LogWrite "$(Get-TimeStamp): Script has been completed."
    exit
}