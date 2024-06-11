PlayState = Class{__includes = BaseState}


function PlayState:enter(params)
    self.highScores = params.highScores
    self.mode = params.mode
    self.snake = params.snake
    self.snake.state = 'play'
    self.snake.mode = self.mode
    self.newPr = false
    


    self.pause = false
end

function PlayState:update(dt)
    if  love.keyboard.wasPressed('s') then
        if self.snake.sound then
            self.snake.sound = false
        else
            self.snake.sound = true
        end
    end
    if  love.keyboard.wasPressed('space') then
        gSounds['select']:play()
        if self.pause == true then
            self.pause = false
        else
            self.pause = true
        end
    end

    if self.snake.direction == 'stop' or self.snake.direction == 'none' then
        self.pause = false
    end
    if self.pause == true then
        return
    end




    if self.snake.direction ~= 'stop' then
        self.snake:update(dt)
        local high = self.highScores[self.mode].score
        self.highScores[self.mode].score = math.max(self.highScores[self.mode].score, self.snake.score)
        if self.snake.score > high then
            self.newPr = true
        end
    end

    if self.snake.direction == 'stop' then
        local scoresStr = ''

        for i = 1, 3 do
            scoresStr = scoresStr .. self.highScores[i].name .. '\n'
            scoresStr = scoresStr .. tostring(self.highScores[i].score) .. '\n'
        end

        love.filesystem.write('snakeScore.lst', scoresStr)
        if love.keyboard.wasPressed('return') then
            gStateMachine:change('start', {
              highScores = self.highScores,
              mode = 1,
              soundMode = self.snake.sound
            })
        end
    end

end

function PlayState:render()
    self.snake:render()
    if self.snake.direction =='stop' then
        if self.newPr then
            love.graphics.setFont(gFonts['medium'])
            love.graphics.setColor(0.6, 0.6, 1, 1)
            love.graphics.print('Congrats,', VIRTUAL_WIDTH /2- 40, 60)
            love.graphics.print('new personal record! ', VIRTUAL_WIDTH /2- 90, 80)
        end
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print('Your final length is ' .. tostring(self.snake.score/10), VIRTUAL_WIDTH /2- 50, 30)
        love.graphics.print('Press \'Enter\' to play again ', VIRTUAL_WIDTH /2- 57, 40)

    end
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle('fill', 0,0,VIRTUAL_WIDTH, 20)
    love.graphics.setColor(0, 1, 1, 1)
    love.graphics.print('Score: ' .. tostring(self.snake.score), VIRTUAL_WIDTH - 50, 2)
    love.graphics.print('PR: ' .. tostring(self.highScores[self.mode].score), VIRTUAL_WIDTH - 50, 11)

    if self.pause == true then
        love.graphics.setFont(gFonts['large'])
        love.graphics.setColor(0, 0, 0, 0.4)
        love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

        love.graphics.print('PAUSE', VIRTUAL_WIDTH/2 , VIRTUAL_HEIGHT/2)

    end
end