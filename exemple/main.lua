local sceneman = require('../sceneman')

local menu = sceneman:new()
menu.load = function()
  print('menu loaded')
end
menu.start = function()
  print('menu started')
end

local game = sceneman:new()
game.load = function()
  print('game loaded')
end

local pause = sceneman:new()
pause.load = function()
  print('pause loaded')
end

function love.load()
  sceneman:load()
  sceneman:start(menu)
end

function love.quit()
  sceneman:quit()
end
