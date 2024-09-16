local barrels = require("scan")
local utils = require("utils")

local chests = barrels.get_barrel_items_table()

utils.print_table(chests, true)


