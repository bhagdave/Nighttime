
-- Heart bar module

-- Define module
local M = {}

function M.new( options )

	-- Default options for instance
	options = options or {}
	local max = options.max or 2
	local spacing = options.spacing or 32
	local w, h = options.width or 64, options.height or 64

	-- Create display group to hold visuals
	local group = display.newGroup()
	group.items = {}
	group.count = 0

	function group:addInventory(type, name, image)
		if group.count < 2 then
			table.insert(self.items, {type, name, "scenes/game/maps/" .. image .. ".png"})
			group.count = group.count + 1
			group:drawInventory()
		end
	end

	function group:dropItem()
		if group.count > 0 then
			self.scene:insertIntoMap(self.items[group.count][3], 70, 20, self.items[group.count][1], self.items[group.count][2])
			if self.items[group.count].image then
				self.items[group.count].image:removeSelf()
			end		
			table.remove(self.items, group.count) 
			group.count = group.count - 1
			group:drawInventory()
			return true
		end
		return false
	end

	function group:getInventoryImage(i)
		return self.items[i][3]
	end

	function group:checkInventory(type, name)
		for k, v in pairs(self.items) do
  			if ( v[1] == type ) and ( v[2] == name ) then
  				return k
  			end
		end
		return 0
	end

	function group:removeAllItems(itemCount)
		group:remove(1)
		group:remove(2)
		group:remove(1)
--		group:remove(2)
		self.items = {}
	end

	function group:drawInventory()
		for i = 1, table.getn(self.items) do
			if self.items[i].image then
				self.items[i].image:removeSelf()
			end
			self.items[i].image = display.newImageRect( self:getInventoryImage(i), w, h )
			self.items[i].image.x = (i-1) * ( (w/2) + spacing )
			self.items[i].image.y = 0
			group:insert( self.items[i].image )
		end
	end

	function group:removeIntentoryItem(i)
		self.items[i].image:removeSelf()
		table.remove(self.items, i)
	    group:drawInventory()
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
