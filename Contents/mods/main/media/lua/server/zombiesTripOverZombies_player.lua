--[[
local playersTripOverZombies = {}

local util = require("zombiesTripOverZombies_util")

---@param obj IsoMovingObject|IsoObject
---@param player IsoPlayer|IsoGameCharacter|IsoMovingObject|IsoObject
function playersTripOverZombies.isBehind(obj,player)

    ---@type Vector3
    local playerToObjVector = Vector3.new(player:getX()-obj:getX(), player:getY()-obj:getX(), 0)

    local aForwardVector = player:getForwardDirection()
    playerToObjVector:normalize()
    aForwardVector:normalize()

    local pDot = playerToObjVector:dot(aForwardVector)

    return pDot > 0.6
end


---@param player IsoPlayer|IsoGameCharacter|IsoMovingObject|IsoObject
function playersTripOverZombies.trip(player, object)

    if player:getBumpType() ~= "" then return end

    print("object: "..object:getX()..", "..object:getY())
    print("isBehind: "..tostring(playersTripOverZombies.isBehind(object, player)))

    if not playersTripOverZombies.isBehind(object, player) then return end

    --if not player:getPlayerMoveDir() then return end

    print("player:getBumpType() "..tostring(player:getBumpType()))
    print("isMoving: "..tostring(player:isMoving()))
    print("getMoveDelta: "..tostring(player:getMoveDelta()))
    print("getTurnDelta: "..tostring(player:getTurnDelta()))
    print("getMoveForwardVec: "..tostring(player:getMoveForwardVec():getDirection()))

    player:clearVariable("BumpFallType")
    player:setBumpType("stagger")
    player:setBumpDone(false)
    player:setBumpFall(ZombRand(0, 101) <= 10)
    player:setBumpFallType("pushedFront")
end



---@param player IsoPlayer|IsoGameCharacter|IsoMovingObject|IsoObject
function playersTripOverZombies.update(player)

    ---@type IsoGridSquare
    local square = player:getSquare()

    local bodyHere = square:getDeadBody()
    if bodyHere then if util.isVeryClose(player,bodyHere) then playersTripOverZombies.trip(player, bodyHere) end end

    local objs = square:getMovingObjects()
    for i=0, objs:size()-1 do
        local foundObj = objs:get(i)
        if foundObj and (foundObj ~= player) then
            if instanceof(foundObj, "IsoZombie") then
                ---@type IsoZombie|IsoGameCharacter|IsoMovingObject|IsoObject
                local zombie = foundObj
                if util.isValidTripper(player, zombie) and util.isVeryClose(player,zombie) then
                    playersTripOverZombies.trip(player, zombie)
                end
            end
        end
    end
end


return playersTripOverZombies

--]]