local sceneman = require('../sceneman')

describe('Sceneman', function()

  it('should have no active scene by default', function()
    assert.False(sceneman:hasactive())
  end)

  it('should have an empty scenes table by default', function()
    assert.are.same({}, sceneman.scenes)
  end)

  describe('newscene function', function()
    it('should return a scene object', function()
      local scene = sceneman:newscene()
      assert.is_table(scene)
    end)

    it('scene object are unique', function()
      local scene1 = sceneman:newscene()
      local scene2 = sceneman:newscene()
      assert.are.not_equal(scene1, scene2)
    end)
  end)

  describe('new function', function()
    it('should increase the total number of scenes', function()
      local count = #sceneman.scenes
      local scene = sceneman:new()
      local newcount = #sceneman.scenes
      assert.is.equal(count + 1, newcount)
    end)
  end)

  describe('load function', function()
    it('should call the load function of each scene', function()
      local scene1 = sceneman:new()
      local spyfunc1 = spy.new(scene1.load)
      scene1.load = spyfunc1
      local scene2 = sceneman:new()
      local spyfunc2 = spy.new(scene2.load)
      scene2.load = spyfunc2
      sceneman:load()
      assert.spy(spyfunc1).was_called(1)
      assert.spy(spyfunc2).was_called(1)
    end)
  end)

  describe('start function', function()
    it('should call the start function of the scene', function()
      local scene = sceneman:new()
      local spyfunc = spy.new(scene.start)
      scene.start = spyfunc
      sceneman:start(scene)
      assert.spy(spyfunc).was_called(1)
    end)

    it('should set the given scene has the active scene', function()
      local scene = sceneman:new()
      sceneman:start(scene)
      assert.is.same(scene, sceneman.active)
    end)
  end)

  describe('stop function', function()
    it('should call the stop function of the active scene', function()
      local scene = sceneman:new()
      local spyfunc = spy.new(scene.stop)
      scene.stop = spyfunc
      sceneman:start(scene)
      sceneman:stop()
      assert.spy(spyfunc).was_called(1)
    end)

    it('should set the active scene to nil', function()
      local scene = sceneman:new()
      sceneman:start(scene):stop()
      assert.is.same(nil, sceneman.active)
    end)
  end)

  describe('tofront function', function()
    it('should call the tofront function of the scene', function()
      local scene = sceneman:new()
      local spyfunc = spy.new(scene.tofront)
      scene.tofront = spyfunc
      sceneman:tofront(scene)
      assert.spy(spyfunc).was_called(1)
    end)

    it('should set the given scene has the active scene', function()
      local scene = sceneman:new()
      sceneman:tofront(scene)
      assert.is.same(scene, sceneman.active)
    end)
  end)

  describe('toback function', function()
    it('should call the toback function of the scene', function()
      local scene = sceneman:new()
      local spyfunc = spy.new(scene.toback)
      scene.toback = spyfunc
      sceneman:start(scene):toback()
      assert.spy(spyfunc).was_called(1)
    end)

    it('should set active scene to nil', function()
      local scene = sceneman:new()
      sceneman:start(scene):toback()
      assert.is.same(nil, sceneman.active)
    end)
  end)

  describe('update function', function()
    it('should call the update function of the active scene', function()
      local scene1 = sceneman:new()
      local spyfunc1 = spy.new(scene1.update)
      scene1.update = spyfunc1
      local scene2 = sceneman:new()
      local spyfunc2 = spy.new(scene2.update)
      scene2.update = spyfunc2
      sceneman:start(scene1)
      sceneman:update()
      sceneman:update()
      assert.spy(spyfunc1).was_called(2)
      assert.spy(spyfunc2).was_not_called()
    end)
  end)

  describe('draw function', function()
    it('should call the draw function of the active scene', function()
      local scene1 = sceneman:new()
      local spyfunc1 = spy.new(scene1.draw)
      scene1.draw = spyfunc1
      local scene2 = sceneman:new()
      local spyfunc2 = spy.new(scene2.draw)
      scene2.draw = spyfunc2
      sceneman:start(scene1)
      sceneman:draw()
      sceneman:draw()
      assert.spy(spyfunc1).was_called(2)
      assert.spy(spyfunc2).was_not_called()
    end)
  end)

  describe('quit function', function()
    it('should call the quit function of each scene', function()
      local scene1 = sceneman:new()
      local spyfunc1 = spy.new(scene1.quit)
      scene1.quit = spyfunc1
      local scene2 = sceneman:new()
      local spyfunc2 = spy.new(scene2.quit)
      scene2.quit = spyfunc2
      sceneman:quit()
      assert.spy(spyfunc1).was_called(1)
      assert.spy(spyfunc2).was_called(1)
    end)
  end)
end)
