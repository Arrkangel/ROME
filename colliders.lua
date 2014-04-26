colliders={}

function colliders.newBoxCollider(px,py,w,h)
	local collider={}
	collider.pos={x=px,y=py}
	collider.bounds={w=w,h=h}
	return collider
end

function colliders.bvbCollision(c1,c2)
	local x1=c1.pos.x
	local y1=c1.pos.y
	local w1=c1.bounds.w
	local h1=c1.bounds.h
	local x2=c2.pos.x
	local y2=c2.pos.y
	local w2=c2.bounds.w
	local h2=c2.bounds.h
	return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1
end






