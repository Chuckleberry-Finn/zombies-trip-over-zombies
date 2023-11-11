local zombiesTripOverZombies = {}

local util = require("zombiesTripOverZombies_util")

zombiesTripOverZombies.timeStamps = {}

---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
function zombiesTripOverZombies.trip(zombie)

    local lastTripped = zombiesTripOverZombies.timeStamps[zombie]
    if lastTripped and lastTripped > getTimestampMs() then return end
    zombiesTripOverZombies.timeStamps[zombie] = getTimestampMs()+200

    if zombie:getBumpedChr() or zombie:isOnFloor() or util.badStates[zombie:getCurrentState()] then return end

    if (ZombRand(101) >= SandboxVars.ZombiesTripOverZombies.zombieTripChance) then return end

    if zombie:getMoveSpeed() >= 0.06 then
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
    if not square then return end

    local target = zombie:getTarget()

    if target and util.isVeryClose(zombie,target,0.66) then return end

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