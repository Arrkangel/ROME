--Test File for rome.lua
love.filesystem.load("rome.lua")()

function love.load()
	rome.init()
	local testimage=love.graphics.newImage("gfx/testface.png")
	rome.setSprite(1,testimage)
	player=actors[1]
	player.update=standardPlayerMovement


end
function love.update(dt)
	rome.updateActors(dt)

end
function love.draw()
	rome.renderActors()
	love.graphics.print('Welcome to RÖME!',0,0)
end


