--Framework for 2D platforming games in Löve
rome={}
rome.world={}
rome.world.colliders={}
rome.world.levels={}

rome.actors={}
rome.objects={}
rome.sprites={}
rome.world.physicsCallbacks={}
rome.world.physicsCallbacks.beginContacts={}
rome.world.resetFlag=false
rome.world.postPhysEffects={}

local world=rome.world
local actors=rome.actors
local sprites=rome.sprites
local objects=rome.objects

love.filesystem.load("leveldict.lua")()
love.filesystem.load("colliders.lua")()



function rome.init()
	--set up box2d

	love.physics.setMeter(64)
	physworld=love.physics.newWorld(0,9.81*64,true)
	physworld:setCallbacks(beginContact,endContact,preSolve,postSolve)
	--defined at EOF

	--create player actor
	player={}
	local pos={}
	pos.x=100
	pos.y=100
	player["pos"]=pos
	player.spriteID=1
	local function update(self,dt) return 0 end
	player.update=update						--????
	player.body=love.physics.newBody(physworld,108,108,"dynamic")
	player.shape=love.physics.newRectangleShape(16,16)
	player.fixture=love.physics.newFixture(player.body,player.shape)
	player.fixture:setUserData("player")
	player.fixture:setFriction(0)
	player.fixture:setRestitution(0)
	player.jump=false

	table.insert(rome.actors,player)

	--world vars
	world.gravity=200
	world.xcam=0
	world.ycam=0
	world.currentlevel=1
	world.numlevels=0
	world.width=0
	world.height=0


	

end

function rome.setSprite(id,sprite)
	rome.sprites[id]=sprite
end

function rome.actors.update(dt)
	for index,value in ipairs(rome.actors) do
		value:update(dt)
	end
end

function rome.world.update(dt)
	physworld:update(dt)
	for id,value in ipairs(world.postPhysEffects) do
		value()
		world.postPhysEffects[id]=nil
	end
	rome.world.calculateCameraOffset()
	if rome.world.resetFlag then
		rome.world.resetLevel()
		rome.world.resetFlag=false
	end

end
function rome.world.resetLevel() 
	print("Reseting everything...")
	for i,value in ipairs(rome.objects) do
		rome.objects[i]=nil
		value.body:destroy()
		
	end
	print(world.currentlevel)
	rome.world.parseLevel(world.levels[world.currentlevel])
	player.body:setPosition(108,108)

end
function rome.world.nextLevel()
	print("Player reached win condition")
	world.currentlevel=world.currentlevel+1
	if world.currentlevel>world.numlevels then
		world.currentlevel=1
	end

	rome.world.resetFlag=true
	
end
function rome.world.addLevel(imageData)
	world.numlevels=world.numlevels+1
	table.insert(world.levels,imageData)
end

function rome.world.begin()
	world.currentlevel=1
	rome.world.resetFlag=true
end



function rome.world.parseLevel(imageData)
	local width,height = imageData:getDimensions()
	rome.world.width=width
	rome.world.height=height
	rome.world.leveltexture=love.image.newImageData(width*20,height*20)
	
	for x=0,width-1 do
		for y=0,height-1 do

			local r,g,b,a = imageData:getPixel(x,y)
			colorstring=tile.toString(r,g,b)

			local tiletype=tile[colorstring]

			world[width*x+y]=tiletype
			if not tiletype then
				print(colorstring)
			end
			if tiletype.collides then
				--new physics collision stuff
				local tileobject={}
				tileobject.body=love.physics.newBody(physworld,x*20+10,y*20+10)
				tileobject.shape=love.physics.newRectangleShape(20,20)
				tileobject.fixture=love.physics.newFixture(tileobject.body,tileobject.shape)
				tileobject.fixture:setFriction(0)
				tileobject.fixture:setUserData(tiletype.name)

				if tiletype.beginCallback then
					
					table.insert(rome.world.physicsCallbacks.beginContacts,tiletype.beginCallback)
				end

				table.insert(rome.objects,tileobject)
				--I dont care how terribly inefficient this is

				


				
			end
			local tileimagedata=sprites[tiletype.spriteID]:getData()
			world.leveltexture:paste(tileimagedata,x*20,y*20,0,0,20,20)
		end
	end
	rome.world.levelimage=love.graphics.newImage(rome.world.leveltexture)

end

function rome.world.renderLevel()
	--[[for x=0,world.width-1,1 do
		for y=0,world.height-1,1 do
			local type=world[world.width*x+y]
			local sprite=sprites[type.spriteID]
			local xoff=x*20+world.xcam
			local yoff=y*20+world.ycam
			if sprite then
				if xoff+10>0 and yoff+10>0 and xoff<640 and yoff<480 then
					love.graphics.draw(sprite,xoff,yoff)
				end
			end
		end
	end
	]]--
	love.graphics.draw(world.levelimage,0+world.xcam,0+world.ycam)

end

function rome.world.calculateCameraOffset()
	local xcam=world.xcam
	local ycam=world.ycam

	local px=player.pos.x
	local py=player.pos.y

	xcam=-math.Clamp(px-(world.width*5),0,world.width*20-640)
	ycam=-math.Clamp(py-(world.height*5),0,world.height*20-480)
	--print(xcam.." "..ycam)



	world.xcam=xcam
	world.ycam=ycam

end







function rome.renderActors()
	for index,value in ipairs(rome.actors) do
		local id=value.spriteID
		local sprite=rome.sprites[id]
		if sprite then 
			--with camera offset
			love.graphics.draw(sprite,value.pos.x+world.xcam,value.pos.y+world.ycam)		
			--without camera offset
			--love.graphics.draw(sprite,value.pos.x,value.pos.y)
		end
	end
end

function standardPlayerMovement(actor,dt)
	actor.body:setAngle(0)
	actor.pos.x=actor.body:getX()-8
	actor.pos.y=actor.body:getY()-8

	local xVel,yVel=actor.body:getLinearVelocity()
	if love.keyboard.isDown("right") then
		actor.body:setLinearVelocity(250,yVel)
	end
	if love.keyboard.isDown("left") then
		actor.body:setLinearVelocity(-250,yVel)
	end
	if not love.keyboard.isDown("left") and not love.keyboard.isDown("right") then
		actor.body:setLinearVelocity(0,yVel)
	end
	if love.keyboard.isDown("up") and player.jump==false then
		actor.body:applyForce(0,-1000)
		player.jump=true
	end

	

end


function beginContact(a,b,coll)
	--jump reset check eventually the framework will add callbacks via some sort of observer pattern
	if a:getUserData()=="player" or b:getuserData()=="player" then
		--player.jump=false
		local x1, y1, x2, y2 = coll:getPositions()
		if y1==y2 then
			player.jump=false
		end	
	end
	for id,value in ipairs(world.physicsCallbacks.beginContacts) do
		value(a,b,coll)
	end


end

function endContact(a,b,coll)


end

function preSolve(a,b,coll)


end

function postSolve(a,b,coll)


end




