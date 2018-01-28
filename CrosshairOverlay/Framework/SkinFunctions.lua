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

function CrosshairOverlay:RevertChanges()
	CrosshairOverlay.MainFrame:SetPoint('CENTER', WorldFrame, 0, 35)
end
