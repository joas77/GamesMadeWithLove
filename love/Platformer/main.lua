function love.load()
    Anim8 = require 'libraries/anim8/anim8'
    Wf = require 'libraries/windfield/windfield'

    Sprites = {}
    Sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')

    local grid = Anim8.newGrid(614, 564, Sprites.playerSheet:getWidth(), Sprites.playerSheet:getHeight())
    
    Animations = {}
    Animations.idle = Anim8.newAnimation(grid('1-15', 1), 0.05)
    Animations.jump = Anim8.newAnimation(grid('1-7', 2), 0.05)
    Animations.run = Anim8.newAnimation(grid('1-15', 3), 0.05)

    World = Wf.newWorld(0, 800, false)
    World:setQueryDebugDrawing(true)

    World:addCollisionClass('Platform')
    World:addCollisionClass('Player' --[[, {ignores = {'Platform'}}]])
    World:addCollisionClass('Danger')
    
    require('player')

    Platform = World:newRectangleCollider(250, 400, 300, 100, {collision_class = "Platform"})
    Platform:setType("static")

    DangerZone = World:newRectangleCollider(0, 550, 800, 50, {collision_class = "Danger"})
    DangerZone:setType("static")
end

function love.update(dt)
    World:update(dt)
    playerUpdate(dt)
end

function love.draw()
    World:draw()
    drawPlayer()
end

function love.keypressed(key)
    if key == 'up' then 
        if Player.grounded then
            Player:applyLinearImpulse(0, -4000)
        end
        
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local colliders = World:queryCircleArea(x, y, 200, {'Platform', 'Danger'})

        for i, c in ipairs(colliders) do
            c:destroy()
        end
    end
    
end