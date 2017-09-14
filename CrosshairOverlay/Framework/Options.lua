-- Author      : Robert
-- Create Date : 9/8/2017 3:12:10 PM

function CrosshairOverlay:SetActiveThemeSettings(skinName)
	local skinOpt = CrosshairOverlay.skinOptions[skinName]
	if(skinOpt ~= nil) then
		CrosshairOverlay.optionsTable.args.themeSettings.args = skinOpt
	end
end

function CrosshairOverlay:InitializeOptions()
	CrosshairOverlay.skinsPath = [[interface/addons/CrosshairOverlay/Skins/]]
	CrosshairOverlay.optionsTable = {
	  type = "group",
	  args = {
		enable = {
		  name = "Enable",
		  desc = "Enables / disables the addon",
		  type = "toggle",
		  set = function(info,val)
					CrosshairOverlay.db.profile.enabled = val
					if(val) then
						CrosshairOverlay:OnEnable()
					else
						CrosshairOverlay:OnDisable()
					end
				end,
		  get = function(info) return CrosshairOverlay.db.profile.enabled end
		},
		appearance = {
		  name = "Appearance",
		  type = "group",
		  args = {
			theme = {
				name = "Theme",
				type = "select",
				style = "dropdown",
				values = CrosshairOverlay.db.global.skins,
				desc = "Choose which skin to use.",
				set = function(info, value)
						CrosshairOverlay.db.profile.activeSkin = value
						CrosshairOverlay:RefreshConfig()						
					end,
				get = function(info) return CrosshairOverlay.db.profile.activeSkin end
			}
		  }
		},
		themeSettings = {
		  name = "Theme Settings",
		  type = "group",
		  args = {}
		}
	  }
	}
end