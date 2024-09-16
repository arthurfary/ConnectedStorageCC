local functions = {}

-- Function to retrieve all connected barrels (i.e., peripherals of type "minecraft:barrel").
function functions.get_barrels()
    -- Get the names of all connected peripherals.
    local connected_peripherals = peripheral.getNames()
    -- Create a table to store barrels.
    local barrels = {}

    -- Loop through the list of connected peripherals.
    for _, per in pairs(connected_peripherals) do
        -- Check if the peripheral type is "minecraft:barrel".
        if peripheral.getType(per) == "minecraft:barrel" then
            -- If it is a barrel, wrap it into a peripheral object and insert it into the barrels table.
            table.insert(barrels, peripheral.wrap(per))
        end
    end
    
    -- Return the list of wrapped barrel peripherals.
    return barrels
end

-- Function to retrieve all items from the connected barrels.
function functions.get_barrel_items_table()
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
    for _, barrel in pairs(functions.get_barrels()) do
        -- Get the name of the barrel.
        local barrel_name = peripheral.getName(barrel)
        -- List all items in the barrel.
        for slot, item in pairs(barrel.list()) do
            -- If the item is not nil, store its details (name and count) in the items table.
            if item ~= nil then 
                -- Store the slot number, item name, and item count for each item in the barrel.
                if items[barrel] == nil then items[barrel] = {} end
                items[barrel][slot] = {name = item.name, count = item.count}
            end
        end
    end

    -- Return the table containing all items from the barrels.
    return items
end    

-- Function to retrieve all items summed
function functions.get_items_sum()
    -- {
    --     ['minecraft:oak_button'] = 64,
    --     ['computercraft:computer_advanced'] = 2,
    --     ['minecraft:diamond'] = 64,
    --     ['minecraft:chest'] = 65,
    --     ['minecraft:barrel'] = 1,
    --     ['computercraft:wired_modem'] = 64,
    --     ['computercraft:cable'] = 64
    -- }
    local barrel_items_table = functions.get_barrel_items_table()
    local items_sum = {}

    for _, barrel in pairs(barrel_items_table) do
        for _, filled_slot in pairs(barrel) do
            if items_sum[filled_slot['name']] == nil then items_sum[filled_slot['name']] = 0 end
            items_sum[filled_slot['name']] = items_sum[filled_slot['name']] + filled_slot['count']
        end
    end
    
    return items_sum
end



return functions
