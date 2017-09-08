-- Author      : Robert
-- Create Date : 9/8/2017 3:35:59 PM

local skinName = "Circle"
local alpha = 0.5
local Speed = 10 -- Higher number moves crosshair faster

CrosshairOverlay:RegisterMessage("CrosshairOverlay:OnRegister",
	function(event, ...)
		print("CrosshairOverlay:OnRegister: " .. skinName)
		CrosshairOverlay:RegisterSkin(skinName)		
	end)

CrosshairOverlay:RegisterMessage("CrosshairOverlay:" .. skinName .. ":OnInitialize",
	function(event, ...)
		local circle = CrosshairOverlay.MainFrame:CreateTexture(nil, 'BACKGROUND')
		circle:SetTexture(CrosshairOverlay.skinsPath .. "circle")
		circle:SetAllPoints()
		circle:SetAlpha(alpha)
		circle:SetBlendMode('ADD')
		circle:SetVertexColor(6.7, 35.3, 43.5)
		
		local tx = CrosshairOverlay.MainFrame:CreateTexture(nil, 'BACKGROUND')
		tx:SetTexture(CrosshairOverlay.skinsPath .. "arrows")
		tx:SetAllPoints()
		tx:SetVertexColor(1, 1, 1)

		--circle:Show()
		--tx:Show()

		local ag = tx:CreateAnimationGroup()
		ag:SetLooping('REPEAT')
		ag:Play()

		local group = tx:CreateAnimationGroup()
		group:SetToFinalAlpha(true)

		local alpha = group:CreateAnimation('Alpha')
		alpha:SetFromAlpha(0)
		alpha:SetToAlpha(1)
		alpha:SetDuration(0.5)
	end)

CrosshairOverlay:RegisterMessage("CrosshairOverlay:OnRefreshConfig",
	function(event, ...)
		circle:Hide()
		tx:Hide()
	end)