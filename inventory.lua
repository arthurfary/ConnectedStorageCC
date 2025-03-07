local export = {}

-- Load configuration
local config = require("config")

-- Function to retrieve all connected barrels (i.e., peripherals of type "minecraft:barrel").
function export.get_connected_inventories()
	-- Get the names of all connected peripherals.
	local connected_peripherals = peripheral.getNames()
	-- Create a table to store barrels.
	local connected_inventories = {}

	-- Loop through the list of connected peripherals.
	for _, per in pairs(connected_peripherals) do
		-- Check if the peripheral type is "minecraft:barrel" and it's not the input/output barrel.
		-- TODO: make so any type of inventory is usable (can prolly try to get its size)
		if peripheral.getType(per) == "minecraft:barrel" and per ~= config.input_output_barrel_name then
			-- If it is a barrel, wrap it into a peripheral object and insert it into the barrels table.
			table.insert(connected_inventories, peripheral.wrap(per))
		end
	end

	-- Return the list of wrapped barrel peripherals.
	return connected_inventories
end

return export
