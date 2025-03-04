-- Function to ping the network and identify the output barrel
local function ping_output_barrel()
    -- Get the names of all connected peripherals.
    local connected_peripherals = peripheral.getNames()
    -- Create a table to store barrels.
    local barrels = {}

    -- Loop through the list of connected peripherals.
    for _, per in pairs(connected_peripherals) do
        -- Check if the peripheral type is "minecraft:barrel".
        if peripheral.getType(per) == "minecraft:barrel" then
            -- If it is a barrel, wrap it into a peripheral object and insert it into the barrels table.
            table.insert(barrels, per)
        end
    end

    -- If there is only one barrel, it is the output barrel.
    if #barrels == 1 then
        print("Output barrel found: " .. barrels[1])
        return barrels[1]
    else
        print("Error: Multiple barrels found or no barrel found.")
        return nil
    end
end

-- Function to list all barrels connected to the system
local function list_all_barrels()
    -- Get the names of all connected peripherals.
    local connected_peripherals = peripheral.getNames()
    -- Create a table to store barrels.
    local barrels = {}

    -- Loop through the list of connected peripherals.
    for _, per in pairs(connected_peripherals) do
        -- Check if the peripheral type is "minecraft:barrel".
        if peripheral.getType(per) == "minecraft:barrel" then
            -- If it is a barrel, wrap it into a peripheral object and insert it into the barrels table.
            table.insert(barrels, per)
        end
    end

    -- Print the list of barrels
    if #barrels > 0 then
        print("Connected barrels:")
        for _, barrel in pairs(barrels) do
            print("- " .. barrel)
        end
    else
        print("No barrels found.")
    end
end

-- Run the function to list all barrels
list_all_barrels()

-- Run the function and print the result
local output_barrel_name = ping_output_barrel()
if output_barrel_name then
    print("Output barrel name: " .. output_barrel_name)
else
    print("Failed to identify the output barrel.")
end