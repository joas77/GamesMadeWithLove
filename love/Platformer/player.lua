Player = World:newRectangleCollider(360, 100, 40, 100, {collision_class = "Player"})
Player:setFixedRotation(true)
Player.speed = 240
Player.animation = Animations.idle
Player.isMoving = false
Player.direction = 1
Player.grounded = true

function playerUpdate(dt)
    if Player.body then
        local colliders = World:queryRectangleArea(Player:getX() -20, Player:getY() + 50, 40, 2, {'Platform'})
        if #colliders>0 then
            Player.grounded = true
        else
            Player.grounded = false
        end
        
        Player.isMoving = false
        local px, py = Player:getPosition()
        if love.keyboard.isDown('right') then
            Player:setX(px + Player.speed*dt)
            Player.isMoving = true
            Player.direction = 1
        end
        if love.keyboard.isDown('left') then
            Player:setX(px - Player.speed*dt)
            Player.isMoving = true
            Player.direction = -1
        end

        if Player:enter('Danger') then
            Player:destroy() 
        end
    end

    if Player.grounded then
        if Player.isMoving then
            Player.animation = Animations.run
        else
            Player.animation = Animations.idle
        end
        Player.animation:update(dt)
    else
        Player.animation = Animations.jump
    end
end

function drawPlayer()
    local px, py = Player:getPosition()
    Player.animation:draw(Sprites.playerSheet, px, py, nil, 0.25 * Player.direction, 0.25, 130, 300)
end