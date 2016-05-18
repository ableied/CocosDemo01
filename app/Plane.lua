local Plane = class("Plane")
local Bullet = require("app.Bullet")
local json = require("json")

local cGridSize = 1
local scaleRate =1/display.contentScaleFactor
local MIN_SPEED = 0
local MAX_SPEED = 20
local X
local Y
local Dir

local planeSocket

local Node

--生成飞行位移Json
function GetFlyJson(x, y, d)
	local table tbJson ={
	X = x,
	Y = y,
	D =d
	}
	local strJson = json.encode(tbJson)
	--print(strJson)
	return strJson
end

--求小数位
function getFloat(f)
	local ag =  10000
	local n = (math.ceil(f *10000))/10000
	return n
end

function Grid2Pos( x, y )
	local visibleSize = cc.Director:getInstance():getVisibleSize()
	local origin = cc.Director:getInstance():getVisibleOrigin()
	
	local finalX = origin.x + visibleSize.width / 2 + x *cGridSize * scaleRate
	local finalY = origin.y + visibleSize.height / 2 + y *cGridSize * scaleRate
	
	return finalX, finalY
end

function Plane:ctor(node,planeimg,HP,speed,turningSpeed)
	print("Plane:ctor")
	self.Node = node
	--始初化位置
	self.X = 2
	self.Y = 2
		
	if speed<MIN_SPEED then
		self.Speed = MIN_SPEED
	elseif speed >MAX_SPEED then
		self.Speed = MAX_SPEED
	else
		self.Speed = speed
	end
	print(self.Speed)
	
	self.TurningSpeed = turningSpeed
	
	self.Dir = 0
	
	self.spPlane = cc.Sprite:create(planeimg)
	node:addChild(self.spPlane)
	
	self:update()
end

--TODO
function Plane:destroy()
end

--todo
function Plane:stop()
end

--todo
function Plane:start()
end

--飞行
function Plane:fly()
	local step = 1* self.Speed	
	self.X,self.Y = self.X + math.cos(math.rad(self.Dir)) * step, self.Y - math.sin(math.rad(self.Dir)) * step
	--考虑传输流量，截取一定精度位移量
	self.X = getFloat(self.X)
	self.Y =getFloat(self.Y)
end

--刷新飞机实例
function Plane:update(socket)
	local posx, posy = Grid2Pos(self.X,self.Y)
	self.spPlane:setPosition(posx, posy)
	self.spPlane:setRotation(self.Dir)
	--self.spPlane:setPosition(((math.ceil(posx*1000))/1000), ((math.ceil(posy*1000))/1000))
	if socket ~= nil then
		socket:sendString(GetFlyJson(self.X, self.Y, self.Dir))
		--print("send json")
	end
end





--转向
function Plane:turn(DirNum)
	self.Dir = getFloat((self.Dir + DirNum)%360)
end

--射击
function Plane:shoot()
	local BulletDir = self.Dir		--子弹射出方向，取飞机当前飞行方向
	print("子弹方向：",BulletDir)
	local BulletSpeed = 4			--TODO 定义射速
	local BulletRange = 200		--TODO 定义射程
	local BulletCount				--TODO 射弹数
	local BulletCountMAX		--TODO 最大射弹数
	local ReadLoadSpeed		--TODO  子弹装镇速度参数。 整体发射速度为飞机装弹速度加上子弹CD速度。
	local ButtetGunX = self.X
	local ButtetGunY = self.Y
	
	self.Node.spbullet = Bullet.new(self.Node, nil, BulletDir, BulletSpeed, BulletRange, ButtetGunX, ButtetGunY)
	self.Node.spbullet:fly()	
end

return Plane