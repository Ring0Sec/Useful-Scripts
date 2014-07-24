$auditCategories = @("Account Logon","Account Management","Detailed Tracking","DS Access","Logon/Logoff","Object Access","Policy Change","Privilege Use","System")
$accounts = get-wmiobject Win32_UserAccount -filter 'LocalAccount=TRUE' | select-object -expandproperty Name
$password = 'CyberPatriot1'

function setUserPasswords {
	foreach ($i in $accounts) {
		C:\Windows\System32\cmd.exe /C net user $i $password
		}
	}

function run {
	# setup the windows update object 
	Write-host 'Enabling automatic updating and including recommended updates...'
	$UPDATE = (New-Object -com "Microsoft.Update.AutoUpdate").Settings

	# turn automatic updates on
	$UPDATE.NotificationLevel = 4

	# make sure recommended updates are included
	$UPDATE.IncludeRecommendedUpdates = "true"

	# save the changes
	$UPDATE.save()

	# Enable the firewall
	Write-host 'Enabling Windows firewall...'
	# This only works in > Windows 8 and Server 2012
	# Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
	# fall back to older system
	netsh advfirewall set allprofiles state on

	# Set account lockout to 5
	Write-host 'Set account lockout to 5...'
	C:\Windows\System32\cmd.exe /C net accounts /lockoutthreshold:5
	
	# Set up auditing  
	Write-host 'Setting up auditing...'

	foreach ($i in $auditCategories) {
				C:\Windows\System32\cmd.exe /C auditpol.exe /set /category:"$i" /failure:enable
			}
			
	# set up password policy

	# set min length to 8
	C:\Windows\System32\cmd.exe /C net accounts /MINPWLEN:8 /MAXPWAGE:90 /UNIQUEPW:5

	# make sure that all users have non-expiring passwords  
	Write-host 'Make all user passwords expireable, except guest...'
	C:\Windows\System32\cmd.exe /C wmic path Win32_UserAccount where PasswordExpires=false set PasswordExpires=true
	# We don't really want to do this for guest, so make sure it doesn't have an expiring password
	C:\Windows\System32\cmd.exe /C wmic path Win32_UserAccount where Name="Guest" set PasswordExpires=false
	# While we're at it, make sure the guest account is disabled  
	Write-host 'Disabling the guest account...'
	C:\Windows\System32\cmd.exe /C net user Guest /active:no

	# Advise the user to turn complexity requirements on.
	Write-host 'Remember to enable "Password must meet complexity requirements under "Account Policies" -> "Password Policy".'
	Start-process secpol.msc -Wait

	# Offer to set all user passwords
	$set_passwords = read-host 'Do you want to set all user passwords to "CyberPatriot1" (y/n)?'
	Write-host 'WARNING:  This is a quick, easy way to ensure all accounts on your CP image are password protected, but IT SHOULD NEVER BE DONE ON A PRODUCTION MACHINE!'  
	if ($set_passwords -eq 'y') { setUserPasswords }
	else { exit }
	
		# offer to disable the Administrator account
	$disable_admin_account = read-host 'Do you wish to disable the administrator account? (recommended) (y/n)'
	if ($disable_admin_account -eq 'y') {
		C:\Windows\System32\cmd.exe /C net user Administrator /active:no
		}
	else {
	exit
	}
	
	# offer to rename the administrator account
	$rename_admin_account = read-host 'Do you wish to rename the administrator account to "Dude"? (y/n)'
	if ($rename_admin_account -eq 'y') { 
		C:\Windows\System32\cmd.exe /C wmic useraccount where name='Administrator' rename 'Dude'
		}
	else {
	exit
	}
	Write-host "That's it!"

	}


$start = read-host 'This script will enable auto-updating, turn Windows firewall on and setup the local security policy for all users on this PC following CyberPatriot recommendations. Do you want to continue (y/n)?'
if ($start -eq 'y') { run }
else { exit }
