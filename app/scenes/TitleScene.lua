local TitleScene = class("TitleScene",function()
	return display.newScene("TitleScene")
	end)
	
local function createStaticButton(node, imageName, x, y, callback)
	--加入按钮
	cc.ui.UIPushButton.new({normal = imageName, pressed = imageName})
	:onButtonClicked(callback)
	:pos(x, y)	--设定位置
	:addTo(node)
end
	
function TitleScene:onEnter()
	print("here")
	createStaticButton(self,"btn.jpg",display.cx/2, display.cy-200,function()
		print ("clicked")
		local s =require("app.scenes.PlayScene").new()
		display.replaceScene(s,"fade",0.6,display.COLOR_BLACK)
		--[[
		for k,v in pairs(display) do
		print(k,v)
		end
		]]
	end) 
end
	
return TitleScene