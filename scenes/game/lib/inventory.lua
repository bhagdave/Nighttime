
-- Heart bar module

-- Define module
local M = {}

function M.new( options )

	-- Default options for instance
	options = options or {}
	local max = options.max or 2
	local spacing = options.spacing or 16
	local w, h = options.width or 32, options.height or 64

	-- Create display group to hold visuals
	local group = display.newGroup()
	group.items = {}

	function group:addInventory(name)
		table.insert(self.items, {name, "scenes/game/maps/" .. name .. ".png"})
		for i = 1, table.getn(self.items) do
			self.items[i] = display.newImageRect( "scenes/game/maps/keyBlue.png", w, h )
			self.items[i].x = (i-1) * ( (w/2) + spacing )
			self.items[i].y = 0
			group:insert( self.items[i] )
		end
		-- group.count = max
	end

	function group:finalize()
		-- On remove, cleanup instance 
	end

	function group:enterFrame()
	end
	group:addEventListener( "finalize" )
	-- Add our enterFrame listener
	group:addEventListener( "enterFrame", enterFrame )

	-- Return instance
	return group
end

return M
