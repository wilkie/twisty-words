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

smallfont = love.graphics.newImageFont("images/small_letters.png", "abcdefghijklmnopqrstuvwxyz_")

-- background image
image_bg = love.graphics.newImage("images/bg.png")

-- glow images
image_correct   = love.graphics.newImage("images/glow-correct.png")
image_incorrect = love.graphics.newImage("images/glow-incorrect.png")
image_repeated  = love.graphics.newImage("images/glow-repeated.png")

last_result = image_repeated

-- The list of words to find
--   current_words["by_length"] gives a list keyed with the word length (3,4,5, or 6)
--   current_words["by_letter"] gives a list keyed by first letter
--   current_words["letters"] gives the list of unique letters
current_words = {}

-- words that have been found
--   listed by length of word which contains a list where entries are
--   stored in the form {"found"=bool, "word"=string}
--
found_words = {}

function love.load()
  -- Size
  love.graphics.setMode(800,600,false,true,0)
  love.graphics.setCaption("Twisty Words")

  -- Load Initial World
  local words = Dictionary:load("words.dat")

  current_words = words[1]

  local fullword = current_words["by_length"][6][1]

  letters = {}
  for char in fullword:gmatch(".") do
    table.insert(letters, char)
  end

  left = letters
  chosen = {}

  -- Fill found words and mark all as unfound
  for i = 3,6,1 do
    found_words[i] = {}
    for _,check_word in ipairs(current_words["by_length"][i]) do
      entry = {found=false, word=check_word}
      table.insert(found_words[i], entry)
    end
  end

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

function is_word(check)
  if #check < 3 or #check > 6 then
    return false
  end
  for _,word in pairs(current_words["by_length"][#check]) do
    if word == check then
      return true
    end
  end
  return false
end

function have_word(check)
  if #check < 3 or #check > 6 then
    return false
  end
  for _,entry in pairs(found_words[#check]) do
    if entry["word"] == check then
      return entry["found"]
    end
  end
  return false
end

function check_off_word(check)
  if #check < 3 or #check > 6 then
    return
  end
  for _,entry in pairs(found_words[#check]) do
    if entry["word"] == check then
      entry["found"] = true
      return
    end
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
    word = table.concat(chosen)
    if is_word(word) then
      if have_word(word) then
        last_result = image_repeated
      else
        last_result = image_correct
        check_off_word(word)
      end
    else
      last_result = image_incorrect
    end
    for _,char in pairs(chosen) do
      table.insert(left, char)
    end
    chosen = {}
  elseif key == "backspace" then
    if #chosen >= 1 then
      table.insert(left, chosen[#chosen])
      table.remove(chosen, #chosen)
    end
  elseif unicode >= string.byte("a") and unicode <= string.byte("z") then
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
  love.graphics.draw(image_bg, 0, 0)

  -- drawing big letters
  love.graphics.setFont(bigfont)

  -- build display string
  display = table.concat(left)

  -- draw letters left to use
  love.graphics.draw(last_result, 213, 395)
  love.graphics.print(display, 245, 400)

  display = table.concat(chosen)
  
  -- draw chosen letters
  love.graphics.print(display, 245, 220)

  -- draw words found / left to find
  love.graphics.setFont(smallfont)
  
  local y = 10
  local x = 10

  blanks = "___"
  for i = 3, 6, 1 do
    local k = 1
    local start_y = y
    local set_y  = y + smallfont:getHeight()
    local use_set_y = false
    for _,entry in ipairs(found_words[i]) do
      if entry["found"] then
        love.graphics.print(entry["word"], x, y)
      else
        love.graphics.print(blanks, x, y)
      end

      y = y + smallfont:getHeight()
      if i == 3 and k == 6 or k == 12 then
        x = x + 70
        set_y = y
        use_set_y = true
        y = start_y
      elseif i == 4 and k == 6 or k == 12 then
        x = x + 100
        set_y = y
        use_set_y = true
        y = start_y
      end
      k = k + 1
    end
    if use_set_y then
      y = set_y
    end

    if #found_words[i] > 0 then
      x = 10
      y = y + smallfont:getHeight()
    end
    blanks = blanks.."_"
  end
end
