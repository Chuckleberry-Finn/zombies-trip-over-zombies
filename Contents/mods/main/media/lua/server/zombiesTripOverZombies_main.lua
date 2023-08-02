local zombie = require("zombiesTripOverZombies_zombie")
Events.OnZombieUpdate.Add(zombie.update)

--[[
local player = require("zombiesTripOverZombies_player")
Events.OnPlayerUpdate.Add(player.update)
--]]