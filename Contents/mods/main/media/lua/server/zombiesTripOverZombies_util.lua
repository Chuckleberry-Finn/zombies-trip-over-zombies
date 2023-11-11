local util = {}

util.badStates = {
    [ZombieGetUpState.instance()] = true
}

function util.isVeryClose(objA,objB,dist)
    dist = dist or 0.3
    return (math.abs(objA:getX()-objB:getX())<=dist and math.abs(objA:getY()-objB:getY())<=dist)
end

---@param character IsoGameCharacter|IsoMovingObject|IsoObject
---@param otherZombie IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
function util.isValidTripper(character, otherZombie)
    local otherZombieState = otherZombie:getCurrentState()
    local ozStateValid = (otherZombie:isOnFloor() or util.badStates[otherZombieState])
    return ( ozStateValid and ZombieOnGroundState.isCharacterStandingOnOther(character, otherZombie) )
end

return util