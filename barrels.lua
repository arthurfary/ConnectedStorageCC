local barrels = require("scan")
local utils = require("utils")

-- local chests = barrels.get_barrel_items_table()
local item_sum = barrels.get_items_sum()

-- Interface
function menu()
	local barrel_count = #barrels.get_barrels()
	print("Welcome to Barrels")
	print(barrel_count .. " Barrels detected.")
	print("All systems operational")
	print('Use "?" to list commands.')
	print("\n")
	print("> ")

	local choice = read()
	handleChoice(choice)
end

function handleChoice(choice)
	local options = {
		["?"] = "Show this help menu",
	}

	if not options[choice] then
		print("Invalid choice.")
		return
	end

	if choice == "?" then
		print("Available commands are:")
		for command, desc in pairs(options) do
			print(command .. ": " .. desc)
		end
	end
end

menu()

-- utils.print_table(item_sum, true)
