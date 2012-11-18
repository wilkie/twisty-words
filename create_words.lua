local f = assert(io.open("wordlist.txt", "r"))

local primes = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101};

local words = {}
local puzzles = {}
local puzzle_size = 0

-- find all words and puzzle possibilities

for line in f:lines() do
  if #line >= 3 and #line <= 6 then
    calculated_score = 1
    for char in line:gmatch(".") do
      char_index = string.byte(char) - string.byte("a") + 1
      char_score = primes[char_index]
      calculated_score = calculated_score * char_score
    end
    entry = {word=line, score=calculated_score}
    table.insert(words, entry)

    if #line == 6 then
      if not puzzles[calculated_score] then
        puzzles[calculated_score] = {}
        puzzle_size = puzzle_size + 1
      end
    end
  end
end

print("Total of "..puzzle_size.." found!")

-- add words

for _,entry in pairs(words) do
  word  = entry["word"]
  score = entry["score"]

  -- does this word fit into the given puzzle?
  for puzzle_score,words in pairs(puzzles) do
    if puzzle_score % score == 0 then
      table.insert(words, word)
    end
  end
end

-- output puzzles

local out = assert(io.open("words.dat", "w"))
for score,words in pairs(puzzles) do
  out:write(table.concat(words,":").."\n")
end
out:close()
