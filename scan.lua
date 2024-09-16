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


return functions

  

-- for slot, item in pairs(barrels.list()) do
   -- print(("%d x %s in slot %d"):format(item.count, item.name, slot))
-- end
