local export = {}

function export.menu()
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

return export
