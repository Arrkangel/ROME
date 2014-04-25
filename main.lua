--Test File for rome.lua
love.filesystem.load("rome.lua")()

function love.load()
	rome.init()
	love.window.setMode(640,480)
	local testimage=love.graphics.newImage("gfx/testface.png")
	rome.setSprite(1,testimage)
	local empty=love.graphics.newImage("gfx/testempty.png")
	rome.setSprite(2,empty)
	local wall=love.graphics.newImage("gfx/testwall.png")
	rome.setSprite(3,wall)
	player=rome.actors[1]
	player.update=standardPlayerMovement
	local testlevel=love.image.newImageData("level/testlevel.png")
	rome.world.parseLevel(testlevel)
	
end
function love.update(dt)
	rome.actors.update(dt)


end
function love.draw()
	rome.world.renderLevel()
	rome.renderActors()
	love.graphics.print('Welcome to RÖME!',0,0)
end


