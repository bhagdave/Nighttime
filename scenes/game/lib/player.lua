-- Module/class for platfomer hero

-- Use this as a template to build an in-game hero 
local fx = require( "com.ponywolf.ponyfx" )
local composer = require( "composer" )

-- Define module
local M = {}

function M.new( instance, options )
	-- Get the current scene
	local scene = composer.getScene( composer.getSceneName( "current" ) )
	local sounds = scene.sounds
	local inventoryCount = 0
	local inventory = {}

	-- Default options for instance
	options = options or {}

	-- Store map placement and hide placeholder
	instance.isVisible = false
	local parent = instance.parent
	local x, y = instance.x, instance.y

	instance = display.newImageRect( parent, "scenes/game/maps/p1_stand.png", 66, 92);
	instance.x,instance.y = x, y

	-- Add physics
	physics.addBody( instance, "dynamic", { radius = 20, density = 5, bounce = 0, friction =  2.7 } )
	instance.isFixedRotation = true
	instance.anchorY = 0.77

	-- Keyboard control
	local max, acceleration, left, right, flip = 175, 800, 0, 0, 0
	local lastEvent = {}
	local function key( event )
		local phase = event.phase
		local name = event.keyName
		if ( phase == lastEvent.phase ) and ( name == lastEvent.keyName ) then return false end  -- Filter repeating keys
		if phase == "down" then
			if "left" == name or "a" == name then
				left = -acceleration
				--flip = -0.133
			end
			if "right" == name or "d" == name then
				right = acceleration
				--flip = 0.133
			elseif "space" == name or "buttonA" == name or "button1" == name then
				instance:jump()
			end
			if not ( left == 0 and right == 0 ) and not instance.jumping then
				--instance:setSequence( "walk" )
				--instance:play()
			end
		elseif phase == "up" then
			if "left" == name or "a" == name then left = 0 end
			if "right" == name or "d" == name then right = 0 end
			if left == 0 and right == 0 and not instance.jumping then
				--instance:setSequence("idle")
			end
		end
		lastEvent = event
	end

	function instance:btnPressLeft( btn )
		left = -acceleration
	end

	function instance:btnPressRight( btn )
		right = acceleration
	end

	function instance:btnReleaseLeft( btn )
		left = 0
	end

	function instance:btnReleaseRight( btn )
		right = 0
	end

	function instance:btnPressJump()
		instance:jump()
	end

	function instance:jump()
		if not self.jumping then
			self:applyLinearImpulse( 0, -100 )
			--self:setSequence( "jump" )
			self.jumping = true
		end
	end

	function instance:addObject(type, name)
		if inventoryCount > 2 then
			return false
		else
			table.insert(inventory , {type, name})
			return true
		end 
	end

	function instance:hurt()
		fx.flash( self )
		--audio.play( sounds.hurt[math.random(2)] )
		if self.lives:damage() <= 0 then
			-- We died
			fx.fadeOut( function()
				composer.gotoScene( "scenes.refresh", { params = { map = self.filename } } )
			end, 1500, 1000 )
			instance.isDead = true
			instance.isSensor = true
			self:applyLinearImpulse( 0, -100 )
			-- Death animation
			--instance:setSequence( "ouch" )
			self.xScale = 1
			transition.to( self, { xScale = -1, time = 750, transition = easing.continuousLoop, iterations = -1 } )
			-- Remove all listeners
			self:finalize()
		end
	end

	function instance:collision( event )
		local phase = event.phase
		local other = event.other
		local y1, y2 = self.y + 50, other.y - ( other.type == "enemy" and 25 or other.height/2 )
		local vx, vy = self:getLinearVelocity()
		if phase == "began" then
			if not self.isDead and ( other.type == "fly" or other.type == "enemy" ) then
				if y1 < y2 then
					-- Hopped on top of an enemy
					other:die()
				elseif not other.isDead then
					-- They attacked us
					self:hurt()
				end
			elseif self.jumping and vy > 0 and not self.isDead then
				-- Landed after jumping
				self.jumping = false
				if not ( left == 0 and right == 0 ) and not instance.jumping then
					--instance:setSequence( "walk" )
					--instance:play()
				else
					--self:setSequence( "idle" )
				end
			end
		end
	end

	function instance:preCollision( event )
		local other = event.other
		local y1, y2 = self.y + 50, other.y - other.height/2
		if event.contact and ( y1 > y2 ) then
			-- Don't bump into one way platforms
			--if other.floating then
			event.contact.isEnabled = true
			--else
			event.contact.friction = 0.1
			--end
		end
	end

	local function enterFrame()
		-- Do this every frame
		local vx, vy = instance:getLinearVelocity()
		local dx = left + right
		if instance.jumping then dx = dx / 4 end
		if ( dx < 0 and vx > -max ) or ( dx > 0 and vx < max ) then
			instance:applyForce( dx or 0, 0, instance.x, instance.y )
		end
		-- Turn around
		instance.xScale = math.min( 1, math.max( instance.xScale + flip, -1 ) )
	end

	function instance:finalize()
		-- On remove, cleanup instance, or call directly for non-visual
		instance:removeEventListener( "preCollision" )
		instance:removeEventListener( "collision" )
		Runtime:removeEventListener( "enterFrame", enterFrame )
		Runtime:removeEventListener( "key", key )
	end

	-- Add a finalize listener (for display objects only, comment out for non-visual)
	instance:addEventListener( "finalize" )

	-- Add our enterFrame listener
	Runtime:addEventListener( "enterFrame", enterFrame )

	-- Add our key/joystick listeners
	Runtime:addEventListener( "key", key )

	-- Add our collision listeners
	instance:addEventListener( "preCollision" )
	instance:addEventListener( "collision" )

	-- Return instance
	instance.name = "player"
	instance.type = "player"
	return instance
end

return M
