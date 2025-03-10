local inventory = require("inventory")
local fuzzy = require("fuzzy_find")

local export = {}

local function reset_term()
	term.clear()
	term.setCursorPos(1, 1)
end

-- TODO: move to fuzzy when i create my own
local function search_for_item(search_term)
	-- Get fuzzy search results
	local result = fuzzy.filter(search_term, inventory.SHOW_NAMES)

	-- Sort results by score in descending order
	table.sort(result, function(a, b)
		return a[3] > b[3]
	end)

	return result
end

local function handle_action(item)
	reset_term()

	print("Selected item: " .. item.show_name)
	print("Avaliable: " .. item.count)

	print("\nChoose amount to take: ")
	local amount = tonumber(read())

	inventory.move_items(amount, item)

	print("Press any key to return to menu")
	os.pullEvent("key")
end

local function selection_menu(options, header)
	local term_x, term_y = term.getSize()
	local visible_lines = term_y - 4 -- Adjust for header and spacing
	local scroll_offset = 1
	local curr_index = 1

	while true do
		reset_term()
		print(header) -- Ensure the header is visible
		print("\n") -- Space for readability

		-- Adjust scroll when selection moves off-screen
		if curr_index < scroll_offset then
			scroll_offset = curr_index
		elseif curr_index > scroll_offset + visible_lines - 1 then
			scroll_offset = curr_index - visible_lines + 1
		end

		-- Display the visible portion of the list
		for i = 0, visible_lines - 1 do
			local item_index = scroll_offset + i
			if item_index > #options then
				break
			end

			local item_name = inventory.SHOW_NAMES[options[item_index][1]]
			local item_count = inventory.ITEM_SUM[inventory.ITEM_NAMES[options[item_index][1]]]
			local display_str = item_count .. " " .. item_name

			-- Highlight the selected item
			if item_index == curr_index then
				term.setBackgroundColor(colors.white)
				term.setTextColor(colors.black)
			end

			print(display_str .. string.rep(" ", term_x - #display_str))

			if item_index == curr_index then
				term.setBackgroundColor(colors.black)
				term.setTextColor(colors.white)
			end
		end

		-- Handle key events
		local event, key = os.pullEvent("key")

		if key == keys.up and curr_index > 1 then
			curr_index = curr_index - 1
		elseif key == keys.down and curr_index < #options then
			curr_index = curr_index + 1
		elseif key == keys.enter then
			local return_dict = {
				show_name = inventory.SHOW_NAMES[options[curr_index][1]],
				item_name = inventory.ITEM_NAMES[options[curr_index][1]],
				count = inventory.ITEM_SUM[inventory.ITEM_NAMES[options[curr_index][1]]],
			}
			return return_dict
		end
	end
end

local function handle_choice(input)
	if input == "/d" then
		inventory.dump_items()
		return
	end
	-- if not reserved command, search for the item
	local items_found = search_for_item(input)

	-- Display the most similar item based on the search result
	if #items_found > 0 then
		local selected = selection_menu(items_found, "Select an item")
		handle_action(selected)
	else
		print("No items found.")
	end
end


function export.menu()
	reset_term()

	local inventories_count = #inventory.get_connected_inventories()
	print("Welcome to Barrels")

	print(inventories_count .. " Inventories connected, " .. (function()
		local sum = 0
		for _, c in pairs(inventory.ITEM_SUM) do
			sum = sum + c
		end
		return sum
	end)() .. " Items detected.")

	print("All systems operational")

	print("\nSearch item or press enter to list all. /d to dump")

	io.write("> ")

	local input = read()
	handle_choice(input)
end

return export
