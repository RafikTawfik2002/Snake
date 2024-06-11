StartState = Class{__includes = BaseState}


function StartState:enter(params)
    self.highScores = params.highScores

    self.snake = Snake('start', 1)
    self.snake.sound = params.soundMode
    self.mode = params.mode
    self.easy = 1
    self.normal = 0
    self.hard = 0

end

function StartState:update(dt)
    if  love.keyboard.wasPressed('s') then
        if self.snake.sound then
            self.snake.sound = false
        else
            self.snake.sound = true
        end
    end

    if  love.keyboard.wasPressed('down') then
        gSounds['select']:play()
        if self.easy == 1 then
            self.mode = 2
            self.easy = 0
            self.normal = 1
        elseif self.normal == 1 then
            self.mode = 3
            self.normal = 0
            self.hard = 1
        else
            self.mode = 1
            self.hard = 0
            self.easy = 1
        end
    elseif love.keyboard.wasPressed('up') then
        gSounds['select']:play()
        if self.easy == 1 then
            self.mode = 3
            self.easy = 0
            self.hard = 1
        elseif self.normal == 1 then
            self.mode = 1
            self.normal = 0
            self.easy = 1
        else
            self.mode = 2
            self.hard = 0
            self.normal = 1
        end
    end

    if  love.keyboard.wasPressed('return') then
        if self.easy == 1 then
            self.mode = 1
        elseif self.normal == 1 then
            self.mode = 2
        else
            self.mode = 3
        end
        gStateMachine:change('play', {
            highScores = self.highScores,
            mode = self.mode,
            snake = self.snake
        })
    end
    --self.snake:update(dt)
end

function StartState:render()
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle('fill', 0,0,VIRTUAL_WIDTH, 20)
    love.graphics.setColor(0, 1, 1, 1)
    love.graphics.print('Score: ' .. tostring(self.snake.score), VIRTUAL_WIDTH - 50, 2)
    love.graphics.print('PR: ' .. tostring(self.highScores[self.mode].score), VIRTUAL_WIDTH - 50, 11)

    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 1, self.easy, 1)
    love.graphics.print('Easy', VIRTUAL_WIDTH /2- 90, VIRTUAL_HEIGHT/2 +20 )
    love.graphics.setColor(0, 1, self.normal, 1)
    love.graphics.print('Normal', VIRTUAL_WIDTH /2 - 90, VIRTUAL_HEIGHT/2 + 40)
    love.graphics.setColor(0, 1, self.hard, 1)
    love.graphics.print('Hard', VIRTUAL_WIDTH /2 - 90, VIRTUAL_HEIGHT/2 +60)

    love.graphics.setFont(gFonts['small'])
    self.snake:render()


end