require 'src/Dependencies'

-- Physical screen dimention
WINDOW_HEIGHT = 1920
WINDOW_WIDTH = 1080

-- Virtual resolution dimentions
VIRTUAL_HEIGHT = 512
VIRTUAL_WIDTH = 288

function love.load()
    -- Initialize our nearest-neighbour filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Window bar title
    love.window.setTitle('Match 3')

    -- Initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- set music to loop and start
    -- TODO : Setup music

    -- Initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin_game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game_over'] = function() return GameOverState() end
    }
    gStateMachine:change('start')

    -- Keep track of scrolling our background on the X axis
    backgroundX = 0
    backgroundScrolling = 80

    -- Initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true;
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keyPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- Scroll background, used across all states
    backgroundX = backgroundX - backgroundScrolling * dt

    -- If we've scrolled the entire image, reset it to 0
    if background <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- Scrolling background drawn behind every state
    love.graphics.draw(gTextrures['background'], backgroundX, 0)

    gStateMachine:render()
    push:finish()
end