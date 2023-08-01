local zombiesTripOverZombies = {}

function zombiesTripOverZombies.isVeryClose(objA,objB)
    return (math.abs(objA:getX()-objB:getX())<=0.3 and math.abs(objA:getY()-objB:getY())<=0.3)
end

--for OnZombieUpdate event (zombie)
---@param zombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
function zombiesTripOverZombies.update(zombie)

    ---@type IsoGridSquare
    local square = zombie:getSquare()

    local bodyHere = square:getDeadBody()
    if bodyHere then

        if zombiesTripOverZombies.isVeryClose(zombie,bodyHere) then
            if zombie:isSprinting() then
                zombie:setBumpType("trippingFromSprint")
            else
                zombie:setBumpType("stagger")
                zombie:setBumpDone(false)
                zombie:setBumpFall(true)
                zombie:setBumpFallType("pushedBehind")
                --zombie:knockDown(true)
            end
        end
    end

    local objs = square:getMovingObjects()
    for i=0, objs:size()-1 do
        local foundObj = objs:get(i)
        if foundObj and (foundObj ~= zombie) then
            if instanceof(foundObj, "IsoZombie") then
                ---@type IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
                local char = foundObj
                if (not zombie:getBumpedChr()) and (not zombie:isOnFloor()) and (char:isOnFloor()) and
                        ZombieOnGroundState.isCharacterStandingOnOther(zombie, char) and
                        zombiesTripOverZombies.isVeryClose(zombie,char) then

                    zombie:setBumpedChr(char)
                    zombie:knockDown(true)
                end
            end
        end
    end
end

return zombiesTripOverZombies