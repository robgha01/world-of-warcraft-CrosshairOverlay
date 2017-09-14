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
