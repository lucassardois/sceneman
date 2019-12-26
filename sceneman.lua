local sceneman = {}
sceneman.scenes = {}
sceneman.active = nil

-- Create a new scene
function sceneman:newscene(base)
  local scene = base or {}

  scene.loaded = false
  scene.started = false

	scene.load = scene.load or function() end
	scene.start = scene.start or function() end
	scene.update = scene.update or function() end
	scene.draw = scene.draw or function() end
	scene.tofront = scene.tofront or function() end
	scene.toback = scene.toback or function() end
	scene.stop = scene.stop or function() end
	scene.quit = scene.quit or function() end

  function scene:isloaded()
    return self.loaded
  end

  function scene:isactive()
    return sceneman.active == self
  end

  function scene:isstarted()
    return self.started
  end

  return scene
end

-- Create and register a new scene
function sceneman:new(name, base)
  local scene = self:newscene(base)
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

-- Call the load function of a
-- a single scene
function sceneman:load(name, ...)
  local scene = self:get(name)
  scene:load(...)
  scene.loaded = true
  return self
end

-- Call the load function
-- of every scenes
function sceneman:loadall(...)
  for name, scene in pairs(self.scenes) do
    sceneman:load(name, ...)
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
  scene.started = true
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
    self.active.started = false
  end

  self.active = nil
  return self
end

-- Stop all scenes wich
-- are started
function sceneman:stopall(...)
  for _, scene in pairs(self.scenes) do
    if scene:isstarted() then
      scene:stop(...)
      scene.started = false
    end
  end

  self.active = nil
  return self
end

-- Call the quit function of
-- the given scene
function sceneman:quit(name, ...)
  local scene = self:get(name)

  if scene == self.active then
    error('sceneman: can\'t quit active scene')
  end

  if scene:isloaded() then
    scene:quit(...)
  end

  scene.loaded = false
  return self
end

-- Call the quit method of
-- every scene
function sceneman:quitall(...)
  for name, _ in pairs(self.scenes) do
    self:quit(name, ...)
  end
  return self
end

return sceneman
