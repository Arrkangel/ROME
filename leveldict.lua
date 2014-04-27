--tile["RRRGGGBBB"]=type
tile={}


function tile.winCallback(a,b,coll)
	
	if (a:getUserData()=="winspot" and b:getUserData()=="player") or
		(a:getUserData()=="player" and b:getUserData()=="winspot") then
		rome.world.nextLevel()
	end
end
function tile.deathCallback(a,b,coll)
	if (a:getUserData()=="deathspot" and b:getUserData()=="player") or
		(a:getUserData()=="player" and b:getUserData()=="deathspot") then
		print("YOU DIED")
		table.insert(rome.world.postPhysEffects,function() player.body:setPosition(100,100) end)
	end
end





tile["000000000"]={name="empty",spriteID=2,collides=false,beginCallback=nil}
tile["000000255"]={name="wall",spriteID=3,collides=true,beginCallback=nil}
tile["000255000"]={name="winspot",spriteID=4,collides=true,beginCallback=tile.winCallback}
tile["255000000"]={name="deathspot",spriteID=5,collides=true,beginCallback=tile.deathCallback}

function tile.toString(r,g,b)
	local rs=""
	local gs=""
	local bs=""
	if r<100 then
		if r<10 then
			rs="00"..r
		else
			rs="0"..r
		end
	else
		rs=r
	end
	if g<100 then
		if g<10 then
			gs="00"..g
		else
			gs="0"..g
		end
	else
		gs=g
	end
	if b<100 then
		if b<10 then
			bs="00"..b
		else
			bs="0"..b
		end
	else
		bs=b
	end
	return rs..gs..bs
end


