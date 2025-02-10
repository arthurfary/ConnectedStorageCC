local barrels = require("scan")
local utils = require("utils")
local fuzzy = require("fuzzy_find")

-- Interface
function menu()
	local barrel_count = #barrels.get_barrels()
	print("Welcome to Barrels")
	print(barrel_count .. " Barrels detected.")
	print("All systems operational")
	print('Use "?" to list commands.')
	print("\n> ")

	local input = read()
	handle_choice(input)
end

function handle_choice(input)
	local options = {
		["?"] = "Show this help menu",
	}

	if not options[input] then
		print("Invalid choice.")
		return
	end

	if input == "?" then
		print("Available commands are:")
		for command, desc in pairs(options) do
			print(command .. ": " .. desc)
		end
		return
	end

	--TODO: MAKE SO 10 OR SO RESULTS ARE DISPLAYED

	-- if not reserved command, search for the item
	local items_found = search_for_item(input)

	-- Display the most similar item based on the search result
	if #items_found > 0 then
		print(items_found[1][1]) -- Print the most similar item name (first result)
	else
		print("No items found.")
	end
end

function search_for_item(search_term)
	local item_names = barrels.get_item_names()

	-- Get fuzzy search results
	local result = fuzzy.filter(search_term, item_names)

	-- Sort results by score in descending order
	table.sort(result, function(a, b)
		return a[3] > b[3]
	end)

	return result
end

menu()
