local barrels = require("scan")
local utils = require("utils")
local fuzzy = require("fuzzy_find")

ITEM_SUM = barrels.get_items_sum()
ITEM_NAMES, SHOW_NAMES = (function()
	local temp_table_names = {}
	local temp_table_show = {}
	for k in pairs(ITEM_SUM) do
		table.insert(temp_table_names, k)
		table.insert(temp_table_show, string.match(k:gsub("_", " "), ":(.*)"))
	end
	return temp_table_names, temp_table_show
end)()

-- Interface
function menu()
	reset_term()

	local barrel_count = #barrels.get_barrels()
	print("Welcome to Barrels")

	print(barrel_count .. " Barrels connected, " .. (function()
		local sum = 0
		for _, c in pairs(ITEM_SUM) do
			sum = sum + c
		end
		return sum
	end)() .. " Items detected.")

	print("All systems operational")

	print("\nSearch item or press enter to list all.")

	io.write("> ")

	local input = read()
	handle_choice(input)
end

function reset_term()
	term.clear()
	term.setCursorPos(1, 1)
end

function selection_menu(options, header)
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

			local item_name = SHOW_NAMES[options[item_index][1]]
			local item_count = ITEM_SUM[ITEM_NAMES[options[item_index][1]]]
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
				show_name = SHOW_NAMES[options[curr_index][1]],
				item_name = ITEM_NAMES[options[curr_index][1]],
				count = ITEM_SUM[ITEM_NAMES[options[curr_index][1]]],
			}
			return return_dict
		end
	end
end

function handle_action(item)
	reset_term()

	print("Selected item: " .. item.show_name)
	print("Avaliable: " .. item.count)

	print("\nChoose amount to take: ")
	local amount = read()
end

function handle_choice(input)
	-- if not reserved command, search for the item
	local items_found = search_for_item(input)

	-- Display the most similar item based on the search result
	if #items_found > 0 then
		--TODO:02/10/2025 Make a menu for the selected item, so it can be brought to the player
		local selected = selection_menu(items_found, "Select an item")
		handle_action(selected)
	else
		print("No items found.")
	end
end

function search_for_item(search_term)
	-- Get fuzzy search results
	local result = fuzzy.filter(search_term, SHOW_NAMES)

	-- Sort results by score in descending order
	table.sort(result, function(a, b)
		return a[3] > b[3]
	end)

	return result
end

menu()
