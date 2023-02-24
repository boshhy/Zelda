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

end

function Projectile:update(dt)
    --TODO adjust movement according to direction
    if self.direction == "left" then
        self.x = self.x - 120 * dt
    elseif self.direction == 'right'  then
        self.x = self.x + 120 * dt
    elseif self.direction == 'up'  then
        self.y = self.y - 120 * dt
    elseif self.direction == 'down'  then
        self.y = self.y + 120 * dt
    end
end

function Projectile:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Projectile:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[
        self.state].frame or self.frame],
        math.floor(self.x + adjacentOffsetX), math.floor(self.y + adjacentOffsetY))

    -- TODO need to delte these lines
    love.graphics.setColor(1, 0, 1, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
end