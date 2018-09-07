
local composer = require( "composer" )
local fx = require( "com.ponywolf.ponyfx" )
local tiled = require( "com.ponywolf.ponytiled" )
local physics = require( "physics" )
local json = require( "json" )
local scene = composer.newScene()
local heartBar = require( "scenes.game.lib.health" )
local inventory = require( "scenes.game.lib.inventory" )
local widget = require( "widget" )
local maskValue = 2.75
local sceneGroup
-- local variables
local map, player, lives
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- ---------
-- Function to scroll the map
local function enterFrame( event )
    local elapsed = event.time
    -- Easy way to scroll a map based on a character
    if player and player.x and player.y and not player.isDead then
        local x, y = player:localToContent( 0, 0 )
        x, y = display.contentCenterX - x, display.contentCenterY - y
        map.x, map.y = map.x + x, map.y + y
        sceneGroup.maskX = display.contentCenterX 
        sceneGroup.maskY = display.contentCenterY
        sceneGroup.maskScaleX = player.lightValue
        sceneGroup.maskScaleY = player.ligthValue
        --print (maskValue)
    end
end

local function torchGoingOut()
    if player.lightValue > 0.25 then    
        player.lightValue = player.lightValue - .01
    end
end


--------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    -- Start physics
    physics.start()
    physics.setGravity( 0, 32 )

    -- load the map
    local filename = event.params.map or "scenes/game/maps/level1.json"
    local mapData = json.decodeFile( system.pathForFile( filename, system.ResourceDirectory ) )
    if (mapData) then
        map = tiled.new( mapData, "scenes/game/maps" )
        map.xScale, map.yScale = 0.85, 0.85
        -- Find our player
        map.extensions = "scenes.game.lib."
        map:extend( "player" )
        player = map:findObject( "player" )
        player.filename = filename

        local mask = graphics.newMask( "particle.png" )

        timer.performWithDelay( 736, torchGoingOut, 0 )

        -- Create the widget
        local btnLeft = widget.newButton(
            {
                left = 50,
                top = display.contentHeight - 100,
                id = "left",
                fontSize = 24,
                label = "<<",
                width = 150,
                onPress = player.btnPressLeft,
                onRelease = player.btnReleaseLeft,
                shape = "roundedRect"
            }
        )
        local btnRight = widget.newButton(
            {
                left = 210,
                top = display.contentHeight - 100,
                id = "right",
                label = ">>",
                fontSize = 24,
                width = 150,
                onPress = player.btnPressRight,
                onRelease = player.btnReleaseRight,
                shape = "roundedRect"
            }
        )

        local btnJump = widget.newButton(
            {
                left = display.contentWidth -160,
                top = display.contentHeight - 100,
                id = "up",
                label = "^",
                fontSize = 24,
                width = 150,
                onPress = player.btnPressJump,
                shape = "roundedRect"
            }
        )

        -- enemies
        map:extend("fly", "key", "ghost", "matches")

        -- Add our hearts module
        lives = heartBar.new()
        lives.x = 48
        lives.y = display.screenOriginY + lives.contentHeight / 2 + 16

        -- Add inventory
        itemsBar  =  inventory.new()
        itemsBar.x = display.contentWidth - 128
        itemsBar.y = display.screenOriginY + itemsBar.contentHeight / 2 + 32
        itemsBar.scene = self
        player.items = itemsBar
        player.lives = lives
        sceneGroup:setMask( mask )
        sceneGroup.maskX = player.x
        sceneGroup.maskY = player.y 
        sceneGroup.maskScaleX = maskValue
        sceneGroup.maskScaleY = maskValue
        scene.player = player
        self.map = map
        sceneGroup:insert( map )
    end 
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        fx.fadeIn() -- Fade up from black
        Runtime:addEventListener( "enterFrame", enterFrame )
   elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
    end
end

function scene:insertIntoMap(imageName, x, y, type, name)
    print("Adding " .. type .. " with " .. name)
    newObject = display.newImageRect( self.map, imageName, 64, 64)
    newObject.type = type
    newObject.name = name
    newObject.x = player.x + x
    newObject.y = player.y + y
    physics.addBody(newObject, "static", { isSensor=true })
end

-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener( "enterFrame", enterFrame )
    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
