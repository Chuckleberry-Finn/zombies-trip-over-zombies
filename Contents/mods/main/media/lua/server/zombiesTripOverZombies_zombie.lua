local zombiesTripOverZombies = {}

local util = require("zombiesTripOverZombies_util")


---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
function zombiesTripOverZombies.trip(zombie)
    if zombie:getBumpedChr() or zombie:isOnFloor() or zombie:getCurrentState()==ZombieGetUpState.instance() then return end

    if (ZombRand(101) >= SandboxVars.ZombiesTripOverZombies.zombieTripChance) then return end

    if zombie:getSpeedMod() < 0.6 then
        zombie:setBumpType("trippingFromSprint")
    else
        if SandboxVars.ZombiesTripOverZombies.sprintersOnly == true then return end
        zombie:knockDown(true)
    end
end



--for OnZombieUpdate event (zombie)
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
function zombiesTripOverZombies.update(zombie)

    ---@type IsoGridSquare
    local square = zombie:getSquare()

    local bodyHere = square:getDeadBody()
    if bodyHere then if util.isVeryClose(zombie,bodyHere) then zombiesTripOverZombies.trip(zombie) end end

    local objs = square:getMovingObjects()
    for i=0, objs:size()-1 do
        local foundObj = objs:get(i)
        if foundObj and (foundObj ~= zombie) then
            if instanceof(foundObj, "IsoZombie") then
                ---@type IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
                local otherZombie = foundObj
                if util.isValidTripper(zombie, otherZombie) and util.isVeryClose(zombie,otherZombie) then
                    zombiesTripOverZombies.trip(zombie)
                end
            end
        end
    end
end


return zombiesTripOverZombies