--Framework for 2D platforming games in Löve
rome={}
world={}
actors={}
sprites={}



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
	table.insert(actors,player)
end

function rome.setSprite(id,sprite)
	sprites[id]=sprite
end

function rome.updateActors(dt)
	for index,value in ipairs(actors) do
		value:update(dt)
	end
end


function rome.renderActors()
	for index,value in ipairs(actors) do
		local id=value.spriteID
		local sprite=sprites[id]
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



