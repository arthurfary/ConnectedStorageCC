local barrels = require("scan")
local utils = require("utils")

-- local chests = barrels.get_barrel_items_table()
local item_sum = barrels.get_items_sum()

utils.print_table(item_sum, true)


