--Test File for rome.lua
love.filesystem.load("rome.lua")()

function math.Clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

function love.load()
	rome.init()
	love.window.setMode(640,480)
	local testimage=love.graphics.newImage("gfx/testface.png")
	rome.setSprite(1,testimage)
	local empty=love.graphics.newImage("gfx/testempty.png")
	rome.setSprite(2,empty)
	local wall=love.graphics.newImage("gfx/testwall.png")
	rome.setSprite(3,wall)

	player.update=standardPlayerMovement
	local testlevel=love.image.newImageData("level/testlevel.png")
	rome.world.parseLevel(testlevel)
	
end
function love.update(dt)
	rome.world.calculateCameraOffset()
	rome.actors.update(dt)


end
function love.draw()
	rome.world.renderLevel()
	rome.renderActors()
	love.graphics.print('Welcome to RÖME! -- Beneath the Surface -- The Center of the World is the Top of the Universe',0,0)
end


