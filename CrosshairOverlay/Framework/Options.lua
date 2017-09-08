-- Author      : Robert
-- Create Date : 9/8/2017 3:12:10 PM

function CrosshairOverlay:InitializeOptions()
	CrosshairOverlay.skinsPath = [[Interface/Addons/CrosshairOverlay/Skins/]]
	CrosshairOverlay.optionsTable = {
	  type = "group",
	  args = {
		enable = {
		  name = "Enable",
		  desc = "Enables / disables the addon",
		  type = "toggle",
		  set = function(info,val) CrosshairOverlay.db.profile.enabled = val end,
		  get = function(info) return CrosshairOverlay.db.profile.enabled end
		},
		crosshairSkin = {
		  name = "Crosshair Skin",
		  type = "select",
		  style = "dropdown",
		  values = CrosshairOverlay.db.global.skins,
		  desc = "Choose which skin to use.",
		  set = function(info, value) CrosshairOverlay.db.profile.activeSkin = value end,
		  get = function(info) return CrosshairOverlay.db.profile.activeSkin end
		}
	  }
	}
end