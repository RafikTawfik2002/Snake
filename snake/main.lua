--[[
    Credit for graphics (amazing work!):
    https://opengameart.org/users/buch

    Credit for music (great loop):
    http://freesound.org/people/joshuaempyre/sounds/251461/
    http://www.soundcloud.com/empyreanma
]]

require 'src/Dependencies'

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')


    math.randomseed(os.time())


    love.window.setTitle('Snake')


    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })


    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['ohNo'] = love.audio.newSource('sounds/ohNo.wav', 'static')
    }


    gStateMachine = StateMachine {
        ['play'] = function() return PlayState() end,
        ['start'] =function() return StartState() end
    }
    gStateMachine:change('start', {
        highScores = loadHighScores(),
        mode = 1,
        soundMode = false
    })

    print(loadHighScores())
    -- gSounds['music']:play()
    -- gSounds['music']:setLooping(true)

    love.keyboard.keysPressed = {}
end


function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end


function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end


function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


function love.draw()

    push:apply('start')

    love.graphics.clear(47/255, 79/255, 79/255, 255/255)

    -- local backgroundWidth = gTextures['background']:getWidth()
    -- local backgroundHeight = gTextures['background']:getHeight()

    -- love.graphics.draw(gTextures['background'], 

    --     0, 0, 

    --     0,

    --     VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    gStateMachine:render()

    

    displayFPS()
    
    push:apply('end')
end


function displayFPS()

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end


function loadHighScores()
    love.filesystem.setIdentity('snakeScore')
    --love.filesystem.remove('snakeScore.lst')
    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('snakeScore.lst') then
        print('worked')
        scores = 'Easy    \n' .. '30' .. '\n' .. 'Normal  \n' .. '30' .. '\n' .. 'Hard    \n' ..'30' .. '\n'

        love.filesystem.write('snakeScore.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 3 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

   -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('snakeScore.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 7)
           -- print(scores[counter].name)
        else
            scores[counter].score = tonumber(line)
           -- print(scores[counter].score)
            counter = counter + 1

        end
        line = ''
        -- flip the name flag
        name = not name
    end

    return scores
 end

