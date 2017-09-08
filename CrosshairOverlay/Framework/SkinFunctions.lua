-- Author      : Robert
-- Create Date : 9/8/2017 6:45:47 PM

function CrosshairOverlay:RegisterSkin(skinName)
	--print("Registering skin: " .. skinName)
	CrosshairOverlay.skins[skinName] = skinName
end