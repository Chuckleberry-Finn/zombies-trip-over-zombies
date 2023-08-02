local util = {}

function util.isVeryClose(objA,objB)
    return (math.abs(objA:getX()-objB:getX())<=0.3 and math.abs(objA:getY()-objB:getY())<=0.3)
end

---@param character IsoGameCharacter|IsoMovingObject|IsoObject
---@param otherZombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
function util.isValidTripper(character, otherZombie)
    local otherZombieState = otherZombie:getCurrentState()
    local ozStateValid = (otherZombie:isOnFloor() or otherZombieState == ZombieGetUpState.instance())
    return ( ozStateValid and ZombieOnGroundState.isCharacterStandingOnOther(character, otherZombie) )
end

return util