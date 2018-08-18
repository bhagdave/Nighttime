
-- main
-- Origin. The starting point of your project.
-- This is the only file Corona SDK will require to work. If it doesn't exist, you'll see an error.


local composer = require ("composer")		-- Include the Composer library

-- hide status bar
display.setStatusBar(display.HiddenStatusBar)

-- Removes bottom bar on Android 
if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 then
	native.setProperty( "androidSystemUiVisibility", "lowProfile" )
else
	native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 
end

system.activate("multitouch")


-- goto splash screen
composer.gotoScene("scenes.logo", "crossFade", 1000)