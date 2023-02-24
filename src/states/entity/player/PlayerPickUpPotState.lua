
PlayerPickUpPotState = Class{__includes = BaseState}

function PlayerPickUpPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    local direction = self.player.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif direction == 'right' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y + self.player.height
    end

    -- separate hitbox for the player's sword; will only be active during this state
    self.liftHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    -- sword-left, sword-up, etc
    self.player:changeAnimation('lift-' .. self.player.direction)

end

function PlayerPickUpPotState:enter(params)

    -- restart sword swing sound for rapid swinging
    -- TODO change sound to pick up sound
    gSounds['sword']:stop()
    gSounds['sword']:play()

    -- restart sword swing animation
    self.player.currentAnimation:refresh()

end

function PlayerPickUpPotState:update(dt)
    --TODO
    -- check if hitbox collides with any objects in the scene
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object:collides(self.liftHitbox) and object.liftable then
            object.solid = false
            object.beingCarried = true
            self.player.potBeingCarried = object
            self.player.pickedUp = true
        end
    end
    
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        if self.player.pickedUp then
            self.player.pickedUp = false
            self.player.carrying = true
            self.player:changeState('carrying')
        else
            self.player:changeState('idle')
        end
    end
    -- if love.keyboard.wasPressed('k') then
    --     self.player:changeState('pick-up')
    -- end
end

function PlayerPickUpPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    --
    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(1, 0, 1, 1)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.liftHitbox.x, self.liftHitbox.y,
    --     self.liftHitbox.width, self.liftHitbox.height)
    -- love.graphics.setColor(1, 1, 1, 1)
end