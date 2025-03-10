-- Load configuration
local config = require("config")
local utils = require("utils")

local input_output_inventory = peripheral.wrap(config.input_output_inventory_name)

-- Function to retrieve all connected barrels (i.e., peripherals of type "minecraft:barrel").
local function get_connected_inventories()
    -- Get the names of all connected peripherals.
    local connected_peripherals = peripheral.getNames()
    -- Create a table to store barrels.
    local connected_inventories = {}

    -- Loop through the list of connected peripherals.
    for _, per in pairs(connected_peripherals) do
        -- Check if the peripheral type is "minecraft:barrel" and it's not the input/output barrel.
        -- TODO: make so any type of inventory is usable (can prolly try to get its size)
		-- print(peripheral.getName(peripheral.wrap(per)))
		per_name, per_type = peripheral.getType(per)

        if per_type == "inventory" and per ~= config.input_output_inventory_name and per ~= "back" and per ~= "left" and per ~= "right" and per ~= "top" and per ~= "bottom"
		then
            -- If it is a barrel, wrap it into a peripheral object and insert it into the barrels table.
            table.insert(connected_inventories, peripheral.wrap(per)) 
        end
    end

    -- Return the list of wrapped barrel peripherals.
	-- print(utils.print_table(connected_inventories))
    return connected_inventories
end

-- Function to retrieve all items from the connected barrels.
local function get_barrel_items_table()
    -- output is ordered like this:
    --
    -- {
    --     ['peripheral: 4db1ae85'] = {
    --         [14] = {
    --             ['name'] = 'minecraft:chest',
    --             ['count'] = 64
    --         }
    --     },
    --     ['peripheral: c7ca63b'] = {
    --         [13] = {
    --             ['name'] = 'computercraft:cable',
    --             ['count'] = 64
    --         }
    --     }
    -- }

    -- Create a table to store the items found in barrels.
    local items = {}

    -- Loop through all connected barrels.
    for _, barrel in pairs(get_connected_inventories()) do
        -- Get the name of the barrel.
        local barrel_name = peripheral.getName(barrel)
        -- List all items in the barrel.
        for slot, item in pairs(barrel.list()) do
            -- If the item is not nil, store its details (name and count) in the items table.
            if item ~= nil then
                -- Store the slot number, item name, and item count for each item in the barrel.
                if items[barrel] == nil then
                    items[barrel] = {}
                end
                items[barrel][slot] = { name = item.name, count = item.count }
            end
        end
    end

    -- Return the table containing all items from the barrels.
    return items
end

-- Function to retrieve all items summed
local function get_items_sum()
    -- {
    --     ['minecraft:oak_button'] = 64,
    --     ['computercraft:computer_advanced'] = 2,
    --     ['minecraft:diamond'] = 64,
    --     ['minecraft:chest'] = 65,
    --     ['minecraft:barrel'] = 1,
    --     ['computercraft:wired_modem'] = 64,
    --     ['computercraft:cable'] = 64
    -- }
    local barrel_items_table = get_barrel_items_table()
    local items_sum = {}

    for _, barrel in pairs(barrel_items_table) do
        for _, filled_slot in pairs(barrel) do
            if items_sum[filled_slot["name"]] == nil then
                items_sum[filled_slot["name"]] = 0
            end
            items_sum[filled_slot["name"]] = items_sum[filled_slot["name"]] + filled_slot["count"]
        end
    end

    return items_sum
end

-- Utility function to extract item names from the item sum
local function get_item_names()
    local item_sum = get_items_sum()

    local item_names = {}
    for item_name, _ in pairs(item_sum) do
        table.insert(item_names, item_name)
    end
    return item_names
end

local function dump_items()
    local inventories = get_connected_inventories()
    for slot, item in pairs(input_output_inventory.list()) do
        if item ~= nil then
            for _, inventory in pairs(inventories) do
                local moved = input_output_inventory.pushItems(peripheral.getName(inventory), slot)
                if moved > 0 then
                    break
                end
            end
        end
    end
end

local ITEM_SUM = get_items_sum()
local ITEM_NAMES, SHOW_NAMES = (function()
    local temp_table_names = {}
    local temp_table_show = {}
    for k in pairs(ITEM_SUM) do
        table.insert(temp_table_names, k)
        table.insert(temp_table_show, string.match(k:gsub("_", " "), ":(.*)"))
    end
    return temp_table_names, temp_table_show
end)()

local function move_items(count, item)
    if count > ITEM_SUM[item.item_name] then
        print("Requested more than available")
        return
    end

    local remaining = count
    local barrels_list = get_connected_inventories()

    for _, barrel in pairs(barrels_list) do
        for slot, barrel_item in pairs(barrel.list()) do
            if barrel_item.name == item.item_name then
                local move_count = math.min(remaining, barrel_item.count)
                local moved = barrel.pushItems(peripheral.getName(input_output_inventory), slot, move_count)
                if moved < move_count then
                    print("Output barrel is full")
                    return
                end
                remaining = remaining - move_count
                print(".")
                if remaining <= 0 then
                    print("Items moved successfully")
                    return
                end
            end
        end
    end
end

local export = {
    ITEM_SUM = ITEM_SUM,
    ITEM_NAMES = ITEM_NAMES,
    SHOW_NAMES = SHOW_NAMES,
    get_connected_inventories = get_connected_inventories,
    get_barrel_items_table = get_barrel_items_table,
    get_items_sum = get_items_sum,
    get_item_names = get_item_names,
    move_items = move_items,
    dump_items = dump_items
}

return export
