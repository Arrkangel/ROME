--Framework for 2D platforming games in Löve
rome={}
rome.world={}
rome.world.colliders={}
rome.actors={}
rome.sprites={}

local world=rome.world
local actors=rome.actors
local sprites=rome.sprites

love.filesystem.load("leveldict.lua")()
love.filesystem.load("colliders.lua")()



function rome.init()
	--create player actor
	player={}
	local pos={}
	pos.x=100
	pos.y=100
	player["pos"]=pos
	player.spriteID=1
	local function update(self,dt) return 0 end
	player.update=update
	player.collider=colliders.newBoxCollider(pos.x,pos.y,16,16)
	player.jump=false
	player.jumpval=0
	table.insert(rome.actors,player)

	--world vars
	world.gravity=200
	world.xcam=0
	world.ycam=0
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

			local r,g,b,a = imageData:getPixel(x,y)
			colorstring=tile.toString(r,g,b)

			local tiletype=tile[colorstring]

			world[width*x+y]=tiletype
			if tiletype.collides then
				local collider=colliders.newBoxCollider(x*20,y*20,20,20)
				table.insert(rome.world.colliders,collider)
			end
		end
	end

end

function rome.world.renderLevel()
	for x=0,world.width-1,1 do
		for y=0,world.height-1,1 do
			local type=world[world.width*x+y]
			local sprite=sprites[type.spriteID]
			if sprite then
				love.graphics.draw(sprite,x*20+world.xcam,y*20+world.ycam)
			end
		end
	end
end
function rome.world.actorCollision(actor)
	for id,value in ipairs(world.colliders) do
		if colliders.bvbCollision(value,actor.collider) then
			
			return true
		end
	end
	return false
end
function rome.world.calculateCameraOffset()
	local xcam=world.xcam
	local ycam=world.ycam

	local px=player.pos.x
	local py=player.pos.y

	xcam=-math.Clamp(px-(world.width*5),0,world.width*10)
	ycam=-math.Clamp(py-(world.height*5),0,world.height*10)
	print(xcam.." "..ycam)

	world.xcam=xcam
	world.ycam=ycam

end







function rome.renderActors()
	for index,value in ipairs(rome.actors) do
		local id=value.spriteID
		local sprite=rome.sprites[id]
		if sprite then
			love.graphics.draw(sprite,value.pos.x+world.xcam,value.pos.y+world.ycam)		
		end
	end
end

function standardPlayerMovement(actor,dt)
	--actor and player used interchangeably here, thats bad, fix this
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
      player.jump=false
   end
   
   
   player.collider.pos.x=x
   player.collider.pos.y=y
   if not rome.world.actorCollision(player) then
   		actor.pos.x=x
   		actor.pos.y=y
	end
	--try jump
	if not player.jump then

		if love.keyboard.isDown("up") then
			
      		player.jump=true
      		player.jumpval=500
      		y=y-(player.jumpval*dt)
      		player.collider.pos.y=y
      		if not rome.world.actorCollision(player) then
      			player.pos.y=y
      		end
   		end
   	
   	else
   		if player.jumpval>0 then
   			player.jumpval=player.jumpval-10
   		end
   		y=y-(player.jumpval*dt)
   		player.collider.pos.y=y
   		if not rome.world.actorCollision(player) then
   			
   			player.pos.y=y
   		end
   	end
	--try gravity
	y=y+(world.gravity*dt)
	player.collider.pos.x=x
   	player.collider.pos.y=y
   	if not rome.world.actorCollision(player) then
   		actor.pos.x=x
   		actor.pos.y=y
	else
		player.jump = false
		
	end

end




