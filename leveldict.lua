--tile["RRRGGGBBB"]=type
tile={}
tile["000000000"]={name="empty",spriteID=2,collides=false}
tile["000000255"]={name="wall",spriteID=3,collides=true}

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
			gs="00"..r
		else
			gs="0"..r
		end
	else
		gs=g
	end
	if b<100 then
		if b<10 then
			bs="00"..r
		else
			bs="0"..r
		end
	else
		bs=b
	end
	return rs..gs..bs
end

