local Bullet = class("Bullet")

local cGridSize = 1
local scaleRate =1/display.contentScaleFactor
local Node
local spBullet
local BulletSpeed
local BulletRange
local BulletColdDown		--TODO  子弹CD时间
local Dir = 0
local BulletImg = "bullet_01.png"
local Posx
local Posy
local BulletDis		--子弹已飞行距离

--TODO 重构
local function Grid2Pos( x, y )
	local visibleSize = cc.Director:getInstance():getVisibleSize()
	local origin = cc.Director:getInstance():getVisibleOrigin()
	
	local finalX = origin.x + visibleSize.width / 2 + x *cGridSize * scaleRate
	local finalY = origin.y + visibleSize.height / 2 + y *cGridSize * scaleRate
	
	return finalX, finalY
end

function Bullet:ctor(node, img, dir, speed, range, beginX, beginY)
	print("new Bullet")
	self.Node = node
	self.BulletSpeed = speed
	self.Dir = dir
	print("子弹方向：",self.Dir)
	self.BulletDis = 0
	self.BulletRange = range
	self.Posx , self.Posy = beginX, beginY
	self.spBullet = cc.Sprite:create("bullet_01.png")
	node:addChild(self.spBullet)
	self:update()
	print("子弹产生。", self.Posx, self.Posy)
end

function Bullet:update()
	self.spBullet:setPosition(Grid2Pos(self.Posx, self.Posy))
end

--TODO
function Bullet:fly()
	--print("bulletFlying~","子弹方向：", Dir)
	local step = 1* self.BulletSpeed	
	
	local ScheduleID = nil	--需先定义变理，再赋ScheduleID
	ScheduleID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
		self.Posx,self.Posy = self.Posx + math.cos(math.rad(self.Dir)) * step, self.Posy - math.sin(math.rad(self.Dir)) * step
		self:update()
		self.BulletDis = self.BulletDis + step
		--print("飞行距离：",self.BulletDis)
		--超出射程，注销计时器，子弹消失
		if self.BulletDis >= self.BulletRange then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(ScheduleID)
			self:destroy()
			return
		end			
		--TODO 子弹击中
	end, 0.001, false)
end

--TODO 子弹击中,爆炸动画，效果计算
function Bullet:Hit()
end

--TODO 子弹爆炸动画，子弹类回收。
function Bullet:destroy()
	--print("子弹消失。")
	self.Node:removeChild(self.spBullet)
end
return Bullet