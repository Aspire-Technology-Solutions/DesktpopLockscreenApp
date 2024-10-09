# Desktop & Lockscreen Branding Application

Application designed, to allow the creation and setting of backgrounds and lockscreens for Windows 10 and 11 operating systems, via Microsoft Intune. 

## Background
As Micorosoft Intune, does not support defining the Lockscreen/Wallpaper images via policy unless you have enterprise based licensing; you can either:
- Define the images via Intune Script,
- Win32 App

The drawback to using a script, is:
- they only run once, (remedidiation scripts can rerun, but require enhanced licneses)
- the offer poor reporting vs Intune Apps,
- the offer no verison controlling,
- the images have to be saved in a shared location, often Azure files leading to costs,
- As the script runs once, and often results in a copy to the local drive; simply updating the image isn't enough and the script needs rerun,
- or you could use remote load, but loss of internet connectivty conuld impact this.

The benefits to use a Win32 App, is that it addresses the above chllanges and offers greater control around delivery. 

## Requirements
- Windows 10 +
- 10MB of Disk Space
- Microsoft Intune

## Instructions

### Option 1 - Image File Update
Option 1, is the best apporach for instances where the whole organisation is using the same background/lockscreen image and wil remain rather static.

1. Extract the powershell script and assests folder for the background app to the C:\BackgroundApp\
2. Open the Assets folder,
3. Replace the current Lockscreen.jpg & Background.jpg with your coporate background using the .jpg format as well the same names,
4. Package the application via the Microsoft Win32 Content Prep from https://go.microsoft.com/fwlink/?linkid=2065730
5. Extract the Microsoft Win32 Content Prep tool,
6. Open CMD using Administrator elevation
7. Open the Microsoft Win32 Content Prep tool via CMD,
8. Define the setup folder as "C:\BackgroundApp",
9. Define the setup file as "C:\BackgroundApp\branding.ps1",
10. Define the output location to "C:\BackgroundApp",
11. Open, intune.microsoft.com
12. Select Apps | Windows
13. Select add
14. Select Windows App (win32)
15. Select the intune package just created under C:\BackgroundApp\
16. Define the following settings:
-- Name: Company Branding
-- Description: Background & Lockscreen branding deployment application.
-- Publisher: Aspire Technology Solutions
-- App Verison: 1.0 (increase by one, for each new package update) - this is important, so the app can run the uninstall and install commands correctly to apply any new updates.
-- Owner: Aspire Technology Solutions
17. Select next
18. Define the following values:
-- Install Command: powershell.exe -ExecutionPolicy Bypass -file Branding.ps1 -Mode Install
-- Uninstall command: powershell.exe -ExecutionPolicy Bypass -file Branding.ps1 -Mode Install
-- Installation time required (mins): 5
-- Allow available uninstall: No
-- Install behavior: System
-- Device restart behavior: Determine behavior based on return codes
19. Select next
20. Define the following values:
-- Operating system architecture: x86,x64
-- Minimum operating system: Windows 10 1607
-- Disk space required (MB): 10MB
21. Select next
22. Define the following values:
-- Rules format Manually configure
-- Select Add
--- Path: C:\Background
--- File or folder: Background.Jpg
--- Detection method: Exists
--- Associated with a 32-bit app on 64-bit clients: No
-- Select Add
--- Path: C:\Background
--- File or folder: Lockscreen.jpg
--- Detection method: Exists
--- Associated with a 32-bit app on 64-bit clients: No
23. Select next
24. Define the scope for delivery to All Devices (or amend to your requirements)
25. Review and finish

### Option 2 - Unique Branding
Option 2, is best where diffrent departments and/or business units have different backgrounds, allowing for consideration that users may change teams of the business units.

1. Extract the powershell script and assests folder for the background app to the C:\BackgroundApp\
2. Open the Assets folder,
3. You can either replace the current Lockscreen.jpg & Background.jpg with your coporate background using the .jpg format as well the same names, or
4. Save your PNG or JPG files to the asset folder, in the preferred nameing you would like to use,
5. Amend the section marked variables, to the new file names ensure you amend the below variables only:
   $BackgroundImage = "Background.jpg"
   $LockscreenImage = "Lockscreen.jpg"
   $NewBackgroundName = "Background.jpg"
   $NewLockScreenName = "Lockscreen.jpg"
7. Package the application via the Microsoft Win32 Content Prep from https://go.microsoft.com/fwlink/?linkid=2065730
8. Extract the Microsoft Win32 Content Prep tool,
9. Open CMD using Administrator elevation
10. Open the Microsoft Win32 Content Prep tool via CMD,
11. Define the setup folder as "C:\BackgroundApp",
12. Define the setup file as "C:\BackgroundApp\branding.ps1",
13. Define the output location to "C:\BackgroundApp",
14. Open, intune.microsoft.com
15. Select Apps | Windows
16. Select add
17. Select Windows App (win32)
18. Select the intune package just created under C:\BackgroundApp\
19. Define the following settings:
-- Name: Company Branding
-- Description: Background & Lockscreen branding deployment application.
-- Publisher: Aspire Technology Solutions
-- App Verison: 1.0 (increase by one, for each new package update) - this is important, so the app can run the uninstall and install commands correctly to apply any new updates.
-- Owner: Aspire Technology Solutions
20. Select next
21. Define the following values:
-- Install Command: powershell.exe -ExecutionPolicy Bypass -file Branding.ps1 -Mode Install
-- Uninstall command: powershell.exe -ExecutionPolicy Bypass -file Branding.ps1 -Mode Install
-- Installation time required (mins): 5
-- Allow available uninstall: No
-- Install behavior: System
-- Device restart behavior: Determine behavior based on return codes
22. Select next
23. Define the following values:
-- Operating system architecture: x86,x64
-- Minimum operating system: Windows 10 1607
-- Disk space required (MB): 10MB
24. Select next
25. Define the following values:
-- Rules format Manually configure
-- Select Add
--- Path: C:\Background
--- File or folder: Background.Jpg (or to your custom image file name)
--- Detection method: Exists
--- Associated with a 32-bit app on 64-bit clients: No
-- Select Add
--- Path: C:\Background
--- File or folder: Lockscreen.jpg (or to your custom image file name)
--- Detection method: Exists
--- Associated with a 32-bit app on 64-bit clients: No
26. Select next
27. Define the scope for delivery to All Devices (or amend to your requirements)
28. Review and finish

