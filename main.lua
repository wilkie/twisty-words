-- Require List
require "dictionary"

-- get some somewhat unpredictable seed
math.randomseed(os.time())

-- make sure holding down keys doesn't do anything
love.keyboard.setKeyRepeat(0, 0)

-- contains the letters available in the puzzle
letters = {}

-- contains the letters in play
chosen = {}

-- contains the letters that are unused that can be used to form words
left = {}

-- The font that renders the tiles
bigfont = love.graphics.newImageFont("images/letters.png", "abcdefghijklmnopqrstuvwxyz")

function love.load()
  -- Size
  love.graphics.setMode(800,600,false,true,0)
  love.graphics.setCaption("Twisty Words")

  -- Load Initial World
  local words = Dictionary:load("words.dat")

  local fullword = words[1]["by_length"][6][1]

  letters = {}
  for char in fullword:gmatch(".") do
    table.insert(letters, char)
  end

  left = letters
  chosen = {}

  shuffle()
end

-- Shuffle letters

function shuffle()
  local n = #left
  while n >= 2 do
    -- n is last pertinent index
    local k = math.random(n) -- 1 <= r <= n
    -- swap
    left[n], left[k] = left[k], left[n]
    n = n - 1
  end
end

-- Events

function love.keypressed(key, unicode)
  if key == "escape" then
    -- quit
    love.event.push("q")
  elseif key == " " then
    -- shuffle letters
    shuffle()
  elseif key == "return" then
    for _,char in pairs(chosen) do
      table.insert(left, char)
    end
    chosen = {}
  elseif key == "backspace" then
    if #chosen >= 1 then
      table.insert(left, chosen[#chosen])
      table.remove(chosen, #chosen)
    end
  elseif unicode >= 95 and unicode < 95+26 then
    -- pick a letter, if that letter exists
    for _,char in pairs(left) do
      if char == key then
        table.remove(left, _)
        table.insert(chosen, char)
        return
      end
    end
  end
end

function love.keyreleased(key)
end

function love.update(dt)
end

function love.draw()
	love.graphics.setBackgroundColor(0,0,255)

  -- drawing big letters
  love.graphics.setFont(bigfont)

  -- build display string
  display = table.concat(left)

  -- draw letters left to use
  love.graphics.print(display, 245, 400)

  display = table.concat(chosen)
  
  -- draw chosen letters
  love.graphics.print(display, 245, 200)
end
