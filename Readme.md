# Sceneman
Simple scene manager for lua.
Perfect to use for [Löve2D](https://love2d.org/) projects.

## Documentation
The most important concept in scenman are `scene`. Scenes explain what should be compute and how to draw the result.
**There is maximum one active scene at a time**. This is *always* true.

First you will need to require scenman, it's simple:
```lua
local scenman = require('scenman')
```
You can now access the api trough the scenman table!

First, you will need to create and register you scene:
```lua
-- Create and register in scenman a new scene
-- called 'menu'
local menu = scenman:new('menu')
```
The scene name must be a string and must be unique. This function returns a scene.
My tips would be to create a scenes folder and place all your scenes in that folder. For instance I would create
a file called `scenes/menu.lua`. You must require once your scenes somewhere in your program. You should
do that at the start of your program, the main file seems a good candidate.
```lua
require('scenes.menu')
require('scenes.game')
require('scenes.pause')
```

Now that our *menu* scene is created let's see how to use it.
Each scenes contains the following functions:
```lua
-- Called when the scene is loaded
scene:load()

-- Called when the scene is started
scene:start()

-- Called when the scene is updated
scene:update()

-- Called when the scene is draw
scene:draw()

-- Called when the scene goto front
scene:tofront()

-- Called when the scene goto back
scene:toback()

-- Called when the scene is stopped
scene:stop()

-- Called when sceneman quit
scene:quit()

-- Returns wether the scene is loaded or not 
scene:isloaded()

-- Returns true if the start function of the
-- scene has been called, false if the stop
-- function of the scene has been called
scene:isstarted()

-- Returns wether the scene is the currently
-- beeing drawn and updated scene
scene:isactive()
```

It's super simple to extends functions:
```lua
local sceneman = require('sceneman')

local menu = sceneman:new('menu')

function menu:start()
  print('menu scene started')
end

function menu:update()
  if not self:isactive() return end
  print('the menu scene is active')
end
```

Now that you know how to create scenes and write their logic let's see how to use sceneman to manage them.
First, you will need to load sceneman:
```lua
-- Call the load function of each scenes
-- All the arguments will be passed to the scene's load function
sceneman:loadall(...)

-- You can also specifically load a scene
sceneman:load('menu', ...)

-- After a load the scene:isloaded() function returns true
```

You usually want to load sceneman only once, load functions are the place where you allocate memory and get ressources from the computer.
Once loaded you can start to play with it.
```lua
-- Set the given scene as the active scene
-- and call it's start function.
-- Use it when you need to set the scene
-- to it's initial state.
sceneman:start(sceneName, ...)

-- Set the given scene as the active scene
-- and call it's tofront function.
-- Use it when a previously started scene
-- get back on screen.
sceneman:tofront(sceneName, ...)

-- Call the toback function of the active
-- scene and set to nil the active scene.
-- Use it when you want to put a scene in the
-- "background".
sceneman:toback(sceneName, ...)

-- Stop the current active scene.
-- Set the active scene to nil.
sceneman:stop(...)

-- Stop all scenes wich are started
-- (where scene:isstarted() returnts true)
sceneman:stopall(...)

-- Call the quit function of the given scene
-- only if the isloaded function returns true
sceneman:quit(sceneName, ...)

-- Use sceneman:quit() on each scenes
sceneman:quitall(...)
```

Since every functions return the sceneman table you can chain functions call as follow:
```lua
-- 1. Start the scene called 'menu'
-- 2. Stop the current active scene
-- 3. Start the scene called 'game'
-- 4. Send the current active scene to the background
-- 5. Start the scene called 'pause'
sceneman:start('menu'):stop():start('game'):toback():start('pause')
```

With thoses functions you can easly manage the life of your scene.
Now, to update the logic behind a scene use:
```lua
-- This call the update function of the active scene
sceneman:update(...)
```

And now to draw your scene on the screen:
```lua
-- This call the draw function of the active scene
sceneman:draw(...)
```

## Tests
This project use [busted](http://olivinelabs.com/busted/) to run tests. Simply run the command `busted` at the root of the repo.

## License
This repository use the [MIT license](https://github.com/loustak/scenman/blob/master/License).
