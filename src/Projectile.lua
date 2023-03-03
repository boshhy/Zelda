--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(direction, item, room)
    self.direction = direction
    self.item = item
    self.room = room
    self.texture = item.texture
    self.frame = item.frame
    self.state = item.state
    self.states = item.states
    self.x = item.x
    self.y = item.y

    self.width = item.width
    self.height = item.height
    self.hitSomething = false

    self.startingX = item.x
    self.startingY = item.y
end

function Projectile:update(dt)
    -- adjust pot throw movement according to direction
    if self.direction == "left" then
        self.x = self.x - 90 * dt
    elseif self.direction == 'right'  then
        self.x = self.x + 90 * dt
    elseif self.direction == 'up'  then
        self.y = self.y - 90 * dt
    elseif self.direction == 'down'  then
        self.y = self.y + 90 * dt
    end
end

function Projectile:traveledTooFar(dt)
    -- travels 4 blocks
    if math.abs(self.startingX - self.x) > 64 or math.abs(self.startingY - self.y) > 64 then
        return true
    end

    -- hits wall
    if self.x < 16 + 12 or self.y < 16 + 12
    or self.x > self.room.width * 16 - 12 or self.y > self.room.height * 16 - 9 then
        return true
    end

    return false
end

function Projectile:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Projectile:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[
        self.state].frame or self.frame],
        math.floor(self.x + adjacentOffsetX), math.floor(self.y + adjacentOffsetY))
end
