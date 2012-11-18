-- Dictionary

-- Loads a list of words from a file

Dictionary = {}

function Dictionary:load(filename)
  local f = assert(io.open(filename, "r"))
  local ret = {}

  for line in f:lines() do
    local words = {}

    for i = 3, 6, 1 do
      words[i] = {}
    end

    for word in line:gmatch("[^:]+") do
      if #word >= 3 and #word <= 6 then 
        table.insert(words[#word], word)
      end
    end

    -- create list of unique letters
    local letters = {}
    local hasletter = {}
    for char in words[6][1]:gmatch(".") do
      if not hasletter[char] then
        hasletter[char] = {}
        table.insert(letters, char)
      end
    end

    -- randomize letter ordering
    local n = #letters
    while n >= 2 do
      -- n is last pertinent index
      local k = math.random(n) -- 1 <= r <= n
      -- swap
      letters[n], letters[k] = letters[k], letters[n]
      n = n - 1
    end

    -- fill byletter
    byletter = {}
    for _,char in pairs(letters) do
      byletter[char] = {}
      for i = 3, 6, 1 do
        for _,word in pairs(words[i]) do
          if word:sub(1,1) == char then
            table.insert(byletter[char], word)
          end
        end
      end
    end

    bylength = {}
    for i = 3, 6, 1 do
      bylength[i] = {}
    end

    for char,words in pairs(byletter) do
      for _,word in pairs(words) do
        table.insert(bylength[#word], word)
      end
    end

    -- print out list!
    for _,words in pairs(bylength) do
      for _,word in pairs(words) do
        print(word)
      end
    end

    entry = {}
    entry["by_letter"] = byletter
    entry["by_length"] = bylength
    entry["letters"] = letters
    table.insert(ret, entry)
  end

  -- screw dictionary objects
  return ret
end
