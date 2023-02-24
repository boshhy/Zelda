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

end

function Projectile:update(dt)
    --TODO adjust movement according to direction
    self.item.x = self.item.x + 60 * dt

end

function Projectile:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.item.texture], gFrames[self.item.texture][self.item.states[
        self.item.state].frame or self.item.frame],
        math.floor(self.item.x + adjacentOffsetX), math.floor(self.item.y + adjacentOffsetY))
end