
PlayerIdleCarryingState = Class{__includes = EntityIdleState}

function PlayerIdleCarryingState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerIdleCarryingState:update(dt)

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('carrying')
    end

    -- if love.keyboard.wasPressed('space') then
    --     self.entity:changeState('swing-sword')
    -- end

    -- TODO change to throw animation
    if love.keyboard.wasPressed('k') then
        self.entity.carrying = false
        self.entity:changeState('idle')
    end
end