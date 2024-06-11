
Snake = Class{}

--local SNAKE_SPEED = {[1] = 0.2, [2] = 0.1, [3] = 0.04}
local SNAKE_SPEED = {[1] = 0.2, [2] = 0.1, [3] = 0.04}

function Snake:init(state)
    self.direction = 'none'
    self.x = VIRTUAL_WIDTH/2
    self.y = VIRTUAL_HEIGHT/2
    self.mode = 1

    self.state = state

    self.width = 10
    self.height = self.width
    self.sound = true

    self.body = {
        [1] = {['x'] = self.x, ['y'] = self.y},
        [2] = {['x'] = self.x - self.width, ['y'] = self.y},
        [3] = {['x'] = self.x - self.width*2, ['y'] = self.y}
    }

    self.delta = 0
    self.len = 3

    self.last = self.direction
    self.score = 30
    self.speed = SNAKE_SPEED[self.mode]

    self.apple = {}
    self:appleSpawn()
    self.eaten = false
end

function Snake:update(dt)
    print(self.delta)
    self.speed = SNAKE_SPEED[self.mode]
    if  love.keyboard.wasPressed('right') and self.last ~= 'left' then
        self.direction = 'right'
        if self.sound then
            gSounds['paddle-hit']:play()
        end
    end

    if  love.keyboard.wasPressed('left') and self.last ~= 'right' and self.direction ~= 'none'then
        self.direction = 'left'
        if self.sound then
            gSounds['paddle-hit']:play()
        end
    end
    if  love.keyboard.wasPressed('up') and self.last ~= 'down' then
        self.direction = 'up'
        if self.sound then
            gSounds['paddle-hit']:play()
        end
    end
    if  love.keyboard.wasPressed('down') and self.last ~= 'up' then
        self.direction = 'down'
        if self.sound then
            gSounds['paddle-hit']:play()
        end
    end

    self.delta = self.delta + dt
    if self.delta > self.speed then
        self.delta = 0
        self.last = self.direction
        if self.direction == 'right' then
            self:removeTail()
            table.insert(self.body, 1, {['x'] = self.x + self.width, ['y'] = self.y})
            self.x = self.x + self.width
        elseif self.direction == 'left' then
                self:removeTail()
                   table.insert(self.body, 1, {['x'] = self.x - self.width, ['y'] = self.y})
                   self.x = self.x - self.width
        elseif self.direction == 'up' then
                self:removeTail()
                table.insert(self.body, 1, {['x'] = self.x, ['y'] = self.y - self.width})
                self.y = self.y - self.width
        elseif self.direction == 'down' then
                 self:removeTail()  
                table.insert(self.body, 1, {['x'] = self.x, ['y'] = self.y + self.width})
                self.y = self.y + self.width
        end
    end
    
-- Body collision and apple spawning 



if self.body[1].x == self.apple.x and self.body[1].y == self.apple.y then
   self.eaten = true
   if self.sound then
    gSounds['score']:play()
end
   self:appleSpawn()
end

    for k, block in pairs(self.body) do
        if k > 1 then
             if block.x == self.x and block.y == self.y and self.direction ~= 'stop' then
                self.direction = 'stop'
                gSounds['ohNo']:play()
                gSounds['wall-hit']:play()
             end
        end
    end

-- Boundaries

    if (self.x + self.width > VIRTUAL_WIDTH or  self.x < 0) and self.direction ~= 'stop' then
        self.direction = 'stop'
        if self.sound then
            gSounds['ohNo']:play()
            gSounds['wall-hit']:play()
        end
    end

    if (self.y + self.width  > VIRTUAL_HEIGHT or  self.y - 20 < 0) and self.direction ~= 'stop' then
        self.direction = 'stop'
        if self.sound then
            gSounds['ohNo']:play()
            gSounds['wall-hit']:play()
        end
    end

--   Reset and enlarge functions


    if love.keyboard.wasPressed('r') then
        self:reset()
    end

    self.score = self.len*10
end


function Snake:render()
    if self.state ~= 'start' then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.circle('line', self.apple.x +5, self.apple.y +5, 4)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.circle('fill', self.apple.x +5, self.apple.y +5, 3)
        love.graphics.setColor(0, 1, 0, 0.5)

    end

    for key, block in pairs(self.body) do
        love.graphics.setColor(1, 0, 1, 0)
        love.graphics.rectangle('fill', block.x, block.y, self.width, self.height, 1,1)
        love.graphics.setColor(0, 1, 0, 1)
        if key == 1 then
            love.graphics.setColor(0, 1, 1, 1)
        end
        --Miuns 2 is the default
        if self.direction == 'up' or self.direction == 'down' then
            love.graphics.rectangle('fill', block.x+1, block.y+1, self.width-3, self.height-2,1,1)
        else
            love.graphics.rectangle('fill', block.x+1, block.y+1, self.width-2, self.height-3,1,1)
        end
    end

    if self.sound then
        love.graphics.setColor(0, 0, 0, 0.4)
        love.graphics.print('FX: ON', VIRTUAL_WIDTH - 35, VIRTUAL_HEIGHT - 20)
    else 
        love.graphics.setColor(0, 0, 0, 0.4)
        love.graphics.print('FX: OFF', VIRTUAL_WIDTH - 35, VIRTUAL_HEIGHT - 20)
    end
    

end


function Snake:reset()
    self.direction = 'none'
    self.x = VIRTUAL_WIDTH/2
    self.y = VIRTUAL_HEIGHT/2
    

    self.width = 10
    self.height = self.width

    self.body = {
        [1] = {['x'] = self.x, ['y'] = self.y},
        [2] = {['x'] = self.x - self.width, ['y'] = self.y},
        [3] = {['x'] = self.x - self.width*2, ['y'] = self.y}
    }

    self.delta = 0
    self.len = 3

    self.last = self.direction
end


function Snake:appleSpawn()
    self.eaten = true
    self.apple.x = math.random(0,19)*10
    self.apple.y = math.random(2,19)*10
    for k, block in pairs(self.body) do
        if block.x == self.apple.x and block.y == self.apple.y then
            self:appleSpawn()
        end
    end
end

function Snake:removeTail()
    if self.eaten == true then
        self.len = self.len + 1
    else
        table.remove(self.body, self.len)
    end
    self.eaten = false
end



