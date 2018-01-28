local AceConfigDialog = LibStub('AceConfigDialog-3.0')
local AceGUI = LibStub("AceGUI-3.0")

function CrosshairOverlay:SetActiveThemeSettings(skinName)
	local skinOpt = CrosshairOverlay.skinOptions[skinName]
	if(skinOpt ~= nil) then
		CrosshairOverlay.optionsTable.args.themeSettings.args = skinOpt
	end
end

local optFrameOnClose = function(widget)
	CrosshairOverlay.MainFrame:Hide()
	AceGUI:Release(widget)
end

function CrosshairOverlay:InitializeOptions()
	-- Create a ace container for our options dialog.
	CrosshairOverlay.OptFrame = AceGUI:Create("Frame")
	CrosshairOverlay.OptFrame:SetCallback("OnClose", optFrameOnClose)
	CrosshairOverlay.OptFrame:SetLayout("Flow")
	CrosshairOverlay.OptFrame:Hide()

	-- Create option tables
	CrosshairOverlay.skinsPath = [[interface/addons/CrosshairOverlay/Skins/]]
	CrosshairOverlay.blizOptionsTable = {
		type = "group",
		args = {
			configure = {
				name = "Configure",
				type = "execute",
				func = function()
					InterfaceOptionsFrameCancel_OnClick()
					HideUIPanel(GameMenuFrame)
					CrosshairOverlay.MainFrame:Show()
					
					-- Enable the chosen skin
					CrosshairOverlay:AddDebug("Event", "CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")
					CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")

					AceConfigDialog:Open("CrosshairOverlay", CrosshairOverlay.OptFrame)
				end
			}			
		}
	}
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
		debug = {
		  name = "Debug",
		  desc = "Enables / disables debug",
		  type = "toggle",
		  set = function(info,val) CrosshairOverlay.db.profile.debug = val end,
		  get = function(info) return CrosshairOverlay.db.profile.debug end
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