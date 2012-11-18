-- Require List
require "dictionary"

math.randomseed(os.time())

letters = {}

function love.load()
  -- Size
  love.graphics.setMode(800,600,false,true,0)
  love.graphics.setCaption("Twisty Words")

  -- Load Initial World
  local words = Dictionary:load("words.dat")

  local fullword = words[1]["by_length"][6][1]
  love.graphics.setCaption(fullword)

  letters = {}
  for char in fullword:gmatch(".") do
    table.insert(letters, char)
  end
end

-- Events

function love.keypressed(key, unicode)
  if key == "esc" then
    love.event.push("esc")
  elseif key == "space" then
    -- SHUFFLE LETTERS
  end
end

function love.keyreleased(key)
end

function love.update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(0,0,0)

  --viewport:drawBackground(world)
  --viewport:draw(world)
  --viewport:draw(player)

  --hud:draw(0,600-40, player.energy, player.books, #books, player.brain == 1)
end
