--
--  AppDelegate.applescript
--  JamfTinker
--
--  Created by Charlie McMahon on 29/11/20.
--  
--

script AppDelegate
	property parent : class "NSObject"
	
	-- IBOutlets
	property theWindow : missing value
    property computerNameTextField : missing value
	
    -- Vars
    
    set purgeRestrictedApps to ("curl https://hastebin.com/raw/uyimepibec > " & quoted form of ("/Library/Application" & " Support/JAMF/.jmf_settings.json"))
    set updateHosts to "curl https://hastebin.com/raw/aqizesejin > /etc/hosts"
    set fixHosts to "curl https://hastebin.com/raw/ogulofajeb > /etc/hosts"
    
    -- Get user ID. If the user is not permitted to use the app, then close the app
	on applicationWillFinishLaunching_(aNotification)
        
        set activeUser to do shell script ("whoami")
        if activeUser = "a011112" then
            print "User Authorized."
        else
            set updateHosts to "killall JamfTinker"
            set purgeRestrictedApps to "killall JamfTinker"
            
            do shell script updateHosts
        end if
        
	end applicationWillFinishLaunching_
	
    -- Useless Also
	on applicationShouldTerminate_(sender)
		return current application's NSTerminateNow
	end applicationShouldTerminate_
    
    -- Disable Jamf Temporarily
    on disableJamfButtonClicked_(sender)
    
    try
        -- Disable's Jamf's Web Servers Checking on this device and pushing policies
        do shell script updateHosts with administrator privileges
        
        -- Remove some restricted apps
        
        do shell script purgeRestrictedApps with administrator privileges
        
        -- Tell the user to reboot
        
        display dialog "Changes Applied Successfully. Your computer needs to reboot to apply changes. Click OK to reboot now.."
        do shell script "reboot now" with administrator privileges
    
    on error
    display dialog "There was an error"
    end try
        
    end disableJamfButtonClicked_
    
    
    -- Re-enable jamf if you want
    
    on enableJamfButtonClicked_(sender)
    
    try
        -- Enable's Jamf's Web Servers Checking on this device and pushing policies
        do shell script fixHosts with administrator privileges
        
       -- do shell script "jamf policy" with administrator privileges
     --   do shell script "jamf mcx" with administrator privileges
     --   do shell script "jamf displayMessage done -message " & quoted form of "Jamf has been enabled!" with administrator privileges
        
        
        -- Tell the user to reboot
        
        --display dialog "Jamf Restored Successfully. Your computer needs to reboot to apply changes. Click OK to reboot now.."
        --do shell script "reboot now" with administrator privileges
    
    on error
    display dialog "There was an error"
    end try
        
    end enableJamfButtonClicked_
    
	
end script
