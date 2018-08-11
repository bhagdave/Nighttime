
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 32 )

local gameLoopTimer
local backGroup
local mainGroup
local uiGroup
local player
local background
local platform
local lastEvent = {}
local particleSystem

local function movePlayerLeft( event )
    player.x = player.x - 3
end

local function movePlayerRight( event )
    player.x = player.x + 3
end

local function jumpPlayer()
    player:applyLinearImpulse( player.deltaX / 10, -0.5, player.x, player.y ) 
end

local function key( event )
    local phase = event.phase
    local name = event.keyName
    if ( phase == lastEvent.phase ) and ( name == lastEvent.keyName ) then return false end  -- Filter repeating keys
    if phase == "down" then
        if "left" == name or "a" == name then
            movePlayerLeft()
        end
        if "right" == name or "d" == name then
            movePlayerRight()
        elseif "space" == name or "buttonA" == name or "button1" == name then
            jumpPlayer()
        end
    end
    lastEvent = event
end

local function gameLoop()
    if (player ~= nil) then
        mainGroup.maskX = player.x
        mainGroup.maskY = player.y
--        player.x = player.x + player.deltaX
    end
    -- particleSystem:createParticle(
    -- {
    --     x = display.screenOriginX - 10,
    --     y = 280,
    --     velocityX = 90,
    --     velocityY = -200,
    --     color = { 0.1, 0.2, 0.5, 0.7 },
    --     lifetime = 32.0,
    --     flags = { "water", "colorMixing", "fixtureContactListener" }
    -- })
end


-- Configure image sheet
local sheetOptions =
{
  frames =
  {
    {   -- 1) Player 1
      x = 0,
      y = 0,
      width = 16,
      height = 16
    },
    {   -- 2) Player 2 2
      x = 16,
      y = 0,
      width = 16,
      height = 16
    },
    {   -- 3) Player 3
      x = 32,
      y = 0,
      width = 16,
      height = 16
    }
  }
}
local objectSheet = graphics.newImageSheet( "assets/run.png", sheetOptions )

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    backGroup = display.newGroup()
    sceneGroup:insert( backGroup )

    uiGroup = display.newGroup()
    sceneGroup:insert( uiGroup )

    mainGroup = display.newGroup()
    sceneGroup:insert( mainGroup )
    local mask = graphics.newMask( "particle.png" )
    platform = display.newImageRect( mainGroup, "assets/platform.png", 1000, 50 )
    platform.x = display.contentCenterX - 100
    platform.y = display.contentHeight - 125
    physics.addBody( platform, "static")

    local plat = display.newImageRect( mainGroup, "assets/platform.png", 300, 50 )
    plat.x = display.contentCenterX - 250
    plat.y = display.contentHeight - 200
    physics.addBody( plat, "static")

    player = display.newImageRect( mainGroup, objectSheet, 4, 98, 79 )
    player.deltaX = 0
    player.x = display.contentCenterX
    player.y = display.contentHeight - 200
    mainGroup:setMask( mask )
    mainGroup.maskX = player.x
    mainGroup.maskY = player.y
    mainGroup.maskScaleX = 1.75
    mainGroup.maskScaleY = 1.75
    physics.addBody( player, { radius=30, bounce=0.1 } )
    player.myName = "player"

    -- load buttons
    local left = display.newRect( 75, display.contentHeight - 50, 150, 50 )
    left:setFillColor( 0.5 )
    left:addEventListener( "tap", movePlayerLeft)

    local right = display.newRect( 245, display.contentHeight - 50, 150, 50 )
    right:setFillColor( 0.5 )
    right:addEventListener( "tap", movePlayerRight)

    local jump = display.newRect( display.contentWidth - 75, display.contentHeight - 50, 150, 50 )
    jump:setFillColor( 255, 0, 0 )
    jump:addEventListener( "tap", jumpPlayer)    

    -- particleSystem = physics.newParticleSystem({
    --     filename = "particle.png",
    --     radius = 4,
    --     imageRadius = 6,
    --     colorMixingStrength = 0.1,
    --     blendMode = "add"
    -- })

    -- Load the background
    -- background = display.newImageRect( backGroup, "assets/fullmoon.png", 1920, 1080 )
    -- background.x = display.contentCenterX
    -- background.y = display.contentCenterY
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        gameLoopTimer = timer.performWithDelay( 70, gameLoop, 0 )
        -- Add our key/joystick listeners
        Runtime:addEventListener( "key", key )
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        timer.cancel( gameLoopTimer )
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
    physics.stop()
    Runtime:removeEventListener( "key", key )
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
