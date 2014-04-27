--Test File for rome.lua
love.filesystem.load("rome.lua")()

function math.Clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

--borrowed from love2d.org forums user Azhurkar
local function debugWorldDraw(world)
   local bodies = world:getBodyList()
   
   for b=#bodies,1,-1 do
      local body = bodies[b]
      local bx,by = body:getPosition()
      local bodyAngle = body:getAngle()
      love.graphics.push()
      love.graphics.translate(bx,by)
      love.graphics.rotate(bodyAngle)
      
      math.randomseed(1) --for color generation
      
      local fixtures = body:getFixtureList()
      for i=1,#fixtures do
         local fixture = fixtures[i]
         local shape = fixture:getShape()
         local shapeType = shape:getType()
         local isSensor = fixture:isSensor()
         
         if (isSensor) then
            love.graphics.setColor(0,0,255,96)
         else
            love.graphics.setColor(math.random(32,200),math.random(32,200),math.random(32,200),96)
         end
         
         love.graphics.setLineWidth(1)
         if (shapeType == "circle") then
            local x,y = fixture:getMassData() --0.9.0 missing circleshape:getPoint()
            --local x,y = shape:getPoint() --0.9.1
            local radius = shape:getRadius()
            love.graphics.circle("fill",x,y,radius,15)
            love.graphics.setColor(0,0,0,255)
            love.graphics.circle("line",x,y,radius,15)
            local eyeRadius = radius/4
            love.graphics.setColor(0,0,0,255)
            love.graphics.circle("fill",x+radius-eyeRadius,y,eyeRadius,10)
         elseif (shapeType == "polygon") then
            local points = {shape:getPoints()}
            love.graphics.polygon("fill",points)
            love.graphics.setColor(0,0,0,255)
            love.graphics.polygon("line",points)
         elseif (shapeType == "edge") then
            love.graphics.setColor(0,0,0,255)
            love.graphics.line(shape:getPoints())
         elseif (shapeType == "chain") then
            love.graphics.setColor(0,0,0,255)
            love.graphics.line(shape:getPoints())
         end
      end
      love.graphics.pop()
   end
   
   local joints = world:getJointList()
   for index,joint in pairs(joints) do
      love.graphics.setColor(0,255,0,255)
      local x1,y1,x2,y2 = joint:getAnchors()
      if (x1 and x2) then
         love.graphics.setLineWidth(3)
         love.graphics.line(x1,y1,x2,y2)
      else
         love.graphics.setPointSize(3)
         if (x1) then
            love.graphics.point(x1,y1)
         end
         if (x2) then
            love.graphics.point(x2,y2)
         end
      end
   end
   
   local contacts = world:getContactList()
   for i=1,#contacts do
      love.graphics.setColor(255,0,0,255)
      love.graphics.setPointSize(3)
      local x1,y1,x2,y2 = contacts[i]:getPositions()
      if (x1) then
         love.graphics.point(x1,y1)
      end
      if (x2) then
         love.graphics.point(x2,y2)
      end
   end
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
	local finish=love.graphics.newImage("gfx/testfinish.png")
	rome.setSprite(4,finish)
	local death=love.graphics.newImage("gfx/testdeath.png")
	rome.setSprite(5,death)

	player.update=standardPlayerMovement
	testlevel=love.image.newImageData("level/testlevel2.png")
	rome.world.addLevel(testlevel)
	rome.world.addLevel(love.image.newImageData("level/testlevel.png"))
	--rome.world.addLevel(love.image.newImageData("level/testlevel.png"))
	rome.world.begin()
	
end
function love.update(dt)
	
	rome.world.update(dt)
	rome.actors.update(dt)


end
function love.draw()
	rome.world.renderLevel()
	rome.renderActors()
	love.graphics.print('Welcome to RÖME! -- Beneath the Surface -- The Center of the World is the Top of the Universe',0,0)
	--debugWorldDraw(physworld)
end


