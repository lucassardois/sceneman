local sceneman = require('../sceneman')

local scenemainmenu = sceneman:new()
local scenegame = sceneman:new()
local scenepause = sceneman:new()

sceneman:start(scenemainmenu)
sceneman:start(scenegame)
-- player press pause button
sceneman:start(scenepause)
