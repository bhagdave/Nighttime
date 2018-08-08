
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local gameLoopTimer
local backGroup
local mainGroup
local player
local background

local function gameLoop()

end

local function movePlayer( event )
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
    },
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

    mainGroup = display.newGroup()
    sceneGroup:insert( mainGroup )

    player = display.newImageRect( mainGroup, objectSheet, 4, 98, 79 )
    player.x = display.contentCenterX
    player.y = display.contentHeight - 100
    physics.addBody( player, { radius=30, isSensor=true } )
    player.myName = "player"

    -- Load the background
    background = display.newImageRect( backGroup, "assets/fullmoon.png", 1920, 1080 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    Runtime:addEventListener("touch", movePlayer)
--    display:addEventListener( "tap", movePlayer )
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
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
    Runtime:removeEventListener( "touch", movePlayer )
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
