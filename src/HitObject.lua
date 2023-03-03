-- used to store objects that have been hit

HitObject = Class{}

function HitObject:init(item, room)
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


function HitObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[
        self.state].frame or self.frame],
        math.floor(self.x + adjacentOffsetX), math.floor(self.y + adjacentOffsetY))
end
