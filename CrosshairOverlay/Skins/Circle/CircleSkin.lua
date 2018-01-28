-- Author      : Robert
-- Create Date : 9/8/2017 3:35:59 PM

local circle
local tx
local ag
local rotation
local skinName = "Circle"
local alpha = 0.5
local Speed = 10 -- Higher number moves crosshair faster

CrosshairOverlay:RegisterMessage("CrosshairOverlay:OnRegister",
	function(event, ...)
		-- Register defaults
		if(CrosshairOverlay.db.profile.themeSettings.circle == nil) then
			CrosshairOverlay.db.profile.themeSettings.circle = {
				enableAnimation = false
			}
		end
		
		CrosshairOverlay:RegisterSkin(skinName, {
			enableAnimation = {
			  name = "Animation",
			  desc = "Enables / disables the rotating animation",
			  type = "toggle",
			  set = function(info,val)
						CrosshairOverlay.db.profile.themeSettings.circle.enableAnimation = val
						if(CrosshairOverlay.db.profile.themeSettings.circle.enableAnimation) then
							rotation:SetDuration(5)
							ag:Play()
						else
							rotation:SetDuration(0)
							ag:Finish()
						end
					end,
			  get = function(info) return CrosshairOverlay.db.profile.themeSettings.circle.enableAnimation end
			}
		})
	end)

CrosshairOverlay:RegisterMessage("CrosshairOverlay:" .. skinName .. ":OnInitialize",
	function(event, ...)
		circle = CrosshairOverlay.MainFrame:CreateTexture(nil, 'BACKGROUND')
		circle:Hide()
		circle:SetTexture(CrosshairOverlay.skinsPath .. "Circle/circle")
		circle:SetAllPoints()
		--circle:SetAlpha(alpha)
		circle:SetBlendMode('ADD')
		circle:SetVertexColor(6.7, 35.3, 43.5)
		
		tx = CrosshairOverlay.MainFrame:CreateTexture(nil, 'BACKGROUND')
		tx:Hide()
		tx:SetTexture(CrosshairOverlay.skinsPath .. "Circle/arrows")
		tx:SetAllPoints()
		tx:SetVertexColor(1, 1, 1)
		
		ag = tx:CreateAnimationGroup()
		rotation = ag:CreateAnimation('Rotation')
		rotation:SetDegrees(-360)
		rotation:SetDuration(5)
		ag:SetLooping('REPEAT')
		
		--local group = tx:CreateAnimationGroup()
		--group:SetToFinalAlpha(true)

		--local alpha = group:CreateAnimation('Alpha')
		--alpha:SetFromAlpha(0)
		--alpha:SetToAlpha(100)
		--alpha:SetDuration(0.5)
	end)

CrosshairOverlay:RegisterMessage("CrosshairOverlay:" .. skinName .. ":OnEnable",
	function(event, ...)
		circle:Show()
		tx:Show()		
	end)

CrosshairOverlay:RegisterMessage("CrosshairOverlay:" .. skinName .. ":OnDisable",
	function(event, ...)
		circle:Hide()
		tx:Hide()
	end)