
PlayerPickUpPotState = Class{__includes = BaseState}

function PlayerPickUpPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0
    self.canTween = true

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

    -- separate hitbox for the player's lift box; will only be active during this state
    self.liftHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    -- sword-left, sword-up, etc
    self.player:changeAnimation('lift-' .. self.player.direction)

end

function PlayerPickUpPotState:enter(params)
    gSounds['lift']:play()

    -- restart pickup animation
    self.player.currentAnimation:refresh()

end

function PlayerPickUpPotState:update(dt)
    -- check if hitbox collides with any objects in the scene
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object:collides(self.liftHitbox) and object.liftable then
            object.solid = false
            object.beingCarried = true
            self.player.potBeingCarried = object
            self.player.pickedUp = true

            if self.canTween then
                self.canTween = false
                local y = 8
                local x = 1

                if self.player.direction == 'up' then
                    y = 9
                    x = 0
                end
                if self.player.direction == 'down' then
                    y = 7
                    x = 0
                end
                if self.player.direction == 'right' then
                    x = -1
                end
                
                -- tween pickup to body then abouve head
                Timer.tween(0.4, {
                    [self.player.potBeingCarried] = {x = self.player.x - x ,y = self.player.y - 4}
                })
                :finish(function()
                    Timer.tween(0.2, {
                    [self.player.potBeingCarried] = {y = self.player.y - y}
                    })
                end)
            end
        end
    end
    
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.canTween = true
        if self.player.pickedUp then
            self.player.pickedUp = false
            self.player.carrying = true
            self.player:changeState('carrying')
        else
            self.player:changeState('idle')
        end
    end
end

function PlayerPickUpPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end
