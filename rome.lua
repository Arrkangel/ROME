--Framework for 2D platforming games in Löve
rome={}
rome.world={}
rome.actors={}
rome.sprites={}

local world=rome.world
local actors=rome.actors
local sprites=rome.sprites

love.filesystem.load("leveldict.lua")()



function rome.init()
	--create player actor
	local player={}
	local pos={}
	pos.x=100
	pos.y=100
	player["pos"]=pos
	player.spriteID=1
	local function update(self,dt) return 0 end
	player.update=update
	table.insert(rome.actors,player)
end

function rome.setSprite(id,sprite)
	rome.sprites[id]=sprite
end

function rome.actors.update(dt)
	for index,value in ipairs(rome.actors) do
		value:update(dt)
	end
end

function rome.world.update()

end
function rome.world.parseLevel(imageData)
	local width,height = imageData:getDimensions()
	rome.world.width=width
	rome.world.height=height
	print(width..height)
	for x=0,width-1 do
		for y=0,height-1 do
			print("Hello")
			local r,g,b,a = imageData:getPixel(x,y)
			colorstring=tile.toString(r,g,b)
			print(colorstring)
			local tiletype=tile[colorstring]
			print(tiletype.name)
			world[width*x+y]=tiletype
		end
	end

end

function rome.world.renderLevel()
	for x=0,world.width-1,1 do
		for y=0,world.height-1,1 do
			local type=world[world.width*x+y]
			local sprite=sprites[type.spriteID]
			if sprite then
				love.graphics.draw(sprite,x*20,y*20)
			end
		end
	end
end



function rome.renderActors()
	for index,value in ipairs(rome.actors) do
		local id=value.spriteID
		local sprite=rome.sprites[id]
		if sprite then
			love.graphics.draw(sprite,value.pos.x,value.pos.y)		
		end
	end
end

function standardPlayerMovement(actor,dt)
	local speed=100
	local x=actor.pos.x
	local y=actor.pos.y
	if love.keyboard.isDown("right") then
      x = x + (speed * dt)
   end
   if love.keyboard.isDown("left") then
      x = x - (speed * dt)
   end

   if love.keyboard.isDown("down") then
      y = y + (speed * dt)
   end
   if love.keyboard.isDown("up") then
      y = y - (speed * dt)
   end
   actor.pos.x=x
   actor.pos.y=y
end




