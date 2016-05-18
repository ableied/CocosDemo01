
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)
		
	for k,v in pairs(cc.ui.UIPushButton) do
		print(k,v)
	end
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
