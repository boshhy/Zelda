--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity, room)
    self.entity = entity
    self.room = room

    self.entity:changeAnimation('idle-' .. self.entity.direction)

    if self.entity.carrying then
        self.entity:changeAnimation('idle-carry-' .. self.entity.direction)
    end
    -- used for AI waiting
    self.waitDuration = 0
    self.waitTimer = 0
end

--[[
    We can call this function if we want to use this state on an agent in our game; otherwise,
    we can use this same state in our Player class and have it not take action.
]]
function EntityIdleState:processAI(params, dt)
    if self.waitDuration == 0 then
        self.waitDuration = math.random(5)
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.entity:changeState('walk')
        end
    end
end

function EntityIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))
end
