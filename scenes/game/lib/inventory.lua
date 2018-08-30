
-- Heart bar module

-- Define module
local M = {}

function M.new( options )

	-- Default options for instance
	options = options or {}
	local max = options.max or 2
	local spacing = options.spacing or 8
	local w, h = options.width or 64, options.height or 64

	-- Create display group to hold visuals
	local group = display.newGroup()
	local items = {}
	for i = 1, max do
		items[i] = display.newImageRect( "scenes/game/maps/heart.png", w, h )
		items[i].x = (i-1) * ( (w/2) + spacing )
		items[i].y = 0
		group:insert( items[i] )
	end
	group.count = max

	function group:addInventory(name)
		table.insert(self.items, {name, "assets/" .. name .. ".png"})
	end

	function group:finalize()
		-- On remove, cleanup instance 
	end
	group:addEventListener( "finalize" )

	-- Return instance
	return group
end

return M
