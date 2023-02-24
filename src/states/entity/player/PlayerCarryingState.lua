
PlayerCarryingState = Class{__includes = EntityWalkState}

function PlayerCarryingState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
end

function PlayerCarryingState:update(dt)

    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('carrying-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('carrying-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('carrying-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('carrying-down')
    else
        self.entity:changeState('idle-carry')
    end

    EntityWalkState.update(self, dt)

    self.entity.potBeingCarried.x = self.entity.x
    if self.entity.currentAnimation.bob == true then
        self.entity.potBeingCarried.y = self.entity.y - 8
    else
        self.entity.potBeingCarried.y = self.entity.y - 9
    end
        -- if love.keyboard.wasPressed('space') then
    --     self.entity:changeState('swing-sword')
    -- end
    -- TODO change to throw animation
    if love.keyboard.wasPressed('k') then
        self.entity.carrying = false
        self.entity.potBeingCarried.beingCarried = false
        self.entity.potBeingCarried.solid = true
        self.entity.potBeingCarried = nil
        self.entity:changeState('walk')
    end

    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if self.entity:collides(object) then
            if object.solid then
                if self.entity.direction == 'up' then
                    self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
                end
                if self.entity.direction == 'down' then
                    self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
                end
                if self.entity.direction == 'left' then
                    self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
                end
                if self.entity.direction == 'right' then
                    self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
                end
            end
        end
    end

    -- if we bumped something when checking collision, check any object collisions
    if self.bumped then
        if self.entity.direction == 'left' then
            
            -- temporarily adjust position into the wall, since bumping pushes outward
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-left')
                end
            end

            -- readjust
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'right' then
            
            -- temporarily adjust position
            self.entity.x = self.entity.x + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.y = doorway.y + 4
                    Event.dispatch('shift-right')
                end
            end

            -- readjust
            self.entity.x = self.entity.x - PLAYER_WALK_SPEED * dt
        elseif self.entity.direction == 'up' then
            
            -- temporarily adjust position
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-up')
                end
            end

            -- readjust
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
        else
            
            -- temporarily adjust position
            self.entity.y = self.entity.y + PLAYER_WALK_SPEED * dt
            
            -- check for colliding into doorway to transition
            for k, doorway in pairs(self.dungeon.currentRoom.doorways) do
                if self.entity:collides(doorway) and doorway.open then

                    -- shift entity to center of door to avoid phasing through wall
                    self.entity.x = doorway.x + 8
                    Event.dispatch('shift-down')
                end
            end

            -- readjust
            self.entity.y = self.entity.y - PLAYER_WALK_SPEED * dt
        end
    end
end