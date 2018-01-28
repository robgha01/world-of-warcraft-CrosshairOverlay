-- Author      : Robert
-- Create Date : 9/8/2017 6:45:47 PM

function CrosshairOverlay:RegisterSkin(skinName)
	CrosshairOverlay.skins[skinName] = skinName
	CrosshairOverlay.skinOptions[skinName] = nil
end

function CrosshairOverlay:RegisterSkin(skinName, skinOptions)
	CrosshairOverlay.skins[skinName] = skinName
	CrosshairOverlay.skinOptions[skinName] = skinOptions
end

function CrosshairOverlay:SetYAxis(value)
	CrosshairOverlay:AddDebug("[".. CrosshairOverlay.db.profile.activeSkin .."] Setting Y-Axis", value)
	CrosshairOverlay.MainFrame:SetPoint('CENTER', WorldFrame, 0, value)
end

function CrosshairOverlay:SetDefault()
	CrosshairOverlay:AddDebug("Reverting any changes made by a skin to default")
	CrosshairOverlay.MainFrame:SetFrameLevel(0)
	CrosshairOverlay.MainFrame:SetFrameStrata('BACKGROUND')
	CrosshairOverlay.MainFrame:SetPoint('CENTER', WorldFrame, 0, CrosshairOverlay.db.profile.themeSettings.crosshairYAxis)
	CrosshairOverlay.MainFrame:SetSize(16, 16)
end
