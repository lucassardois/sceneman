local sceneman = {}
sceneman.scenes = {}
sceneman.active = nil

-- Create a new scene
function sceneman:newscene()
  local scene = {}

  function scene:load() end
  function scene:start() end
  function scene:tofront() end
  function scene:toback() end
  function scene:stop() end
  function scene:quit(...)
    -- By default we simply call the
    -- stop function
    self:stop(...)
  end

  function scene:isactive()
    return sceneman.active == self
  end

  function scene:update() end
  function scene:draw() end

  return scene
end

-- Create and register a new scene
function sceneman:new(name)
  local scene = self:newscene()
  -- local index = #self.scenes
  -- self.scenes[index + 1] = scene
  self.scenes[name] = scene
  return scene
end

function sceneman:get(name)
  if type(name) ~= 'string' then
    error('sceneman: scene name must be a string')
  end

  local scene = self.scenes[name]

  if scene == nil then
    error('sceneman: scene "' .. name .. '" not found"')
  end

  return scene
end

-- Call the load function of all the
-- scenes
function sceneman:load(...)
  for _, scene in pairs(self.scenes) do
    scene:load(...)
  end

  return self
end

-- Check wether or not an active
-- scene is set
function sceneman:hasactive()
  return self.active ~= nil
end

-- Set a scene has the active scene
-- and call it's start function
function sceneman:start(name, ...)
  local scene = self:get(name)
  scene:start(...)
  self.active = scene
  return self
end

-- Set a scene has the active scene
-- and call it's tofront function
function sceneman:tofront(name, ...)
  local scene = self:get(name)
  scene:tofront(...)
  self.active = scene
  return self
end

-- Call the toback function of the active
-- scene and set to nil the active scene
function sceneman:toback(...)
  if self:hasactive() then
    self.active:toback(...)
    self.active = nil
  end

  return self
end

function sceneman:update(...)
  if self:hasactive() then
    self.active:update(...)
  end
end

function sceneman:draw(...)
  if self:hasactive() then
    self.active:draw(...)
  end
end

-- Stop the current active scene
function sceneman:stop(...)
  if self:hasactive() then
    self.active:stop(...)
  end

  self.active = nil
  return self
end

-- Call the stop function of every 
-- registered scenes
function sceneman:stopall(...)
  for _, scene in pairs(self.scenes) do
    self.active:stop(...)
  end

  self.active = nil
  return self
end

-- Call the stop function of each scenes
function sceneman:quit(...)
  for _, scene in pairs(self.scenes) do
    scene:quit(...)
  end

  return self
end

return sceneman
