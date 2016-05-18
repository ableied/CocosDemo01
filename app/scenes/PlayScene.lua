local PlayScene = class("PlayScene",function()
	return display.newScene("PlayScene")
end)

local json = require("json")
local Plane = require("app.Plane")

local tickFlush = 0.1
--local touchLayer

local cplane
lll
local spPlane2

--添加按钮方法
local function createStaticButton(node, imageName, x, y, callback)
	cc.ui.UIPushButton.new({normal = imageName, pressed = imageName})
	:onButtonClicked(callback)
	:setAnchorPoint(cc.p(0.0,0.0))
	:pos(x, y)	--设定位置
	:addTo(node)
end

local wsSendText = nil

local function  initWebSocket()
		if wsSendText == nil then
			wsSendText = cc.WebSocket:create("ws://127.0.0.1:3000")
			
			local function wsSendTextOpen(strData)
				print("WebSocket 实例打开")
			end
			
			local function wsSendTextMessage(strData)
				local strInfo = "response text msg : " .. strData
				print(strInfo)
				local tbPostion = json.decode(strData)
				--print(tbPostion["x"], tbPostion["y"])
				print(tbPostion["D"])
				if spPlane2 ~= nil  and tbPostion ~= nil then
					if tbPostion["X"] ~= nil and tbPostion["Y"] ~= nil then
						spPlane2.X = tbPostion["X"]
						spPlane2.Y = tbPostion["Y"]
						spPlane2.Dir = tbPostion["D"]
						spPlane2:update()
					end
				end
			end	
			
			local function wsSendTextClose(strData)
				print("WebSocket 实例关闭。")
			end
			
			local function wsSendTextError(strData)
				print("WebSocket 实例错误发生。")
			end
			
			wsSendText:registerScriptHandler(wsSendTextOpen, cc.WEBSOCKET_OPEN)
			wsSendText:registerScriptHandler(wsSendTextMessage, cc.WEBSOCKET_MESSAGE)
			wsSendText:registerScriptHandler(wsSendTextClose, cc.WEBSOCKET_CLOSE)
			wsSendText:registerScriptHandler(wsSendTextError, cc.WEBSOCKET_ERROR)
		else
			print("WebSocket已存在。")
		end
		
		return wsSendText
end

function PlayScene:onEnter()
	print("PlayScene Start")
		
	createStaticButton(self,"btn.jpg",0, 0,function()
		print ("clicked")
		self.cplane:shoot()
	end) 
	
	createStaticButton(self, "btn02.jpg" , 100, 0, function()
		print("clicked 02")	
		initWebSocket()
	end)
	
	self:ProcessInput()
	
	self.cplane = Plane.new(self,"plane.png",20,1,2.3)
	spPlane2 = Plane.new(self, "plane02.png", 20, 0.1 ,3)	
	
	local tick = function()
		--print('heart beat')
		self.cplane:fly()
		--print(wsSendText)
		self.cplane:update(wsSendText)
		
		--spPlane2:fly()
		--spPlane2:update()
	end
	--cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick,tickFlush,false)
	self:scheduleUpdateWithPriorityLua(tick, 0)
end

--控制输入
function PlayScene:ProcessInput()

	local visibleSize = cc.Director:getInstance():getVisibleSize()	--取得可视区域。
	local origin = cc.Director:getInstance():getVisibleOrigin()
	local ScheduleID = nil

	--onTouchBegan
	local function onTouchBegan(touch, event )
		local location = touch:getLocation()
		local finalX = location.x -(origin.x + visibleSize.width/2)
		local finalY = location.y - (origin.y +visibleSize.height/2)
		
		if location.y >110 then		
			local Scheduler = cc.Director:getInstance():getScheduler()
			ScheduleID = Scheduler:scheduleScriptFunc(function()
				if finalX > 0 then 
					self.cplane:turn(self.cplane.TurningSpeed)	--左转
				elseif finalX < 0 then
					self.cplane:turn(-self.cplane.TurningSpeed)	--右转
				else
					print"finalX = 0"
				end
			end, 0.01, false)
		end
		return true	-- 在 began 状态时，如果要让 Node 继续接收该触摸事件的状态变化
	end
	
	local function onTouchMoved(touch, event)
		local location = touch:getLocation()
		local finalX = location.x -(origin.x + visibleSize.width/2)
		local finalY = location.y - (origin.y +visibleSize.height/2)
		print(finalX, finalY)
	end
	
	local function onTouchEnded(touch , event)
		if ScheduleID ~= nil then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(ScheduleID) 
		end
		print("touchend")
	end
	
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(false)
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	--listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	local eventDispatcher = self:getEventDispatcher()
	--local eventDispatcher = touchLayer:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
	--eventDispatcher:addEventListenerWithSceneGraphPriority(listener, touchLayer)

end

return PlayScene