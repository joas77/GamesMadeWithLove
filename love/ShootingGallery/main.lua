GAME_STATE_MENU = 1
GAME_STATE_PLAY = 2
function love.load()
    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    score = 0
    timer = 10 
    gameState =  GAME_STATE_MENU
    gameFont = love.graphics.newFont(40)

    sprites = {}
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')

    love.mouse.setVisible(false)
end

function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end
    if timer < 0 then
        timer = 0
        gameState = GAME_STATE_MENU
        score = 0
    end
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.print("Score: " .. score, 5, 5)
    love.graphics.print("Time: " .. math.ceil(timer), 300, 5)

    if gameState == GAME_STATE_MENU then
        love.graphics.printf("Click anywhere to begin!", 0, 250, love.graphics.getWidth(), "center")
    end

    if gameState == GAME_STATE_PLAY then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end
        love.graphics.draw(sprites.crosshairs, love.mouse.getX()-20, love.mouse.getY()-20)
    
end

MOUSE_BUTTON_LEFT = 1
MOUSE_BUTTON_RIGHT = 2

--[[
TODO:
Add a feature where the player can right-click in order to shoot a target. 
When right-clicking to shoot, the player will earn 2 points on a successful hit,
but they will also lose 1 second on their timer.
--]]

function love.mousepressed(x, y, button, istouch, presses)
    if button == MOUSE_BUTTON_LEFT and gameState == GAME_STATE_PLAY then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget <= target.radius then
            score = score + 1
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        else
            score = score - 1
            if score <= 0 then
                score = 0
                gameState = GAME_STATE_MENU
            end
        end
    elseif button == MOUSE_BUTTON_LEFT and gameState == GAME_STATE_MENU then
        gameState = GAME_STATE_PLAY
        timer = 10
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end