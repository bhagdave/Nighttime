
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

-- This module turns gamepad axis events and mobile accelerometer events into keyboard
-- events so we don't have to write separate code for joystick, tilt, and keyboard control
require( "com.ponywolf.joykey" ).start()

-- goto splash screen
composer.gotoScene("scenes.logo", "crossFade", 1000)