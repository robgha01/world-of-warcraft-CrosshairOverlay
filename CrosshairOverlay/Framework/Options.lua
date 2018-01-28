local AceConfigDialog = LibStub('AceConfigDialog-3.0')
local AceGUI = LibStub("AceGUI-3.0")

function CrosshairOverlay:SetActiveThemeSettings(skinName)
	local skinOpt = CrosshairOverlay.skinOptions[skinName]
	if(skinOpt ~= nil) then
		CrosshairOverlay.optionsTable.args.themeSettings.args = skinOpt
	end
end

function CrosshairOverlay:InitializeOptions()
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
					
					CrosshairOverlay:AddDebug("Reverting any changes made by a skin to default")
					CrosshairOverlay:RevertChanges()

					-- Enable the chosen skin
					CrosshairOverlay:AddDebug("Event", "CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")
					CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")

					-- Create a ace container for our options dialog.
					local optFrame = AceGUI:Create("Frame")
					optFrame:SetTitle("Crosshair Overlay")
					optFrame:SetCallback("OnClose", function(widget) CrosshairOverlay:AddDebug("Closing options window"); CrosshairOverlay.MainFrame:Hide(); AceGUI:Release(widget) end)
					optFrame:SetLayout("Flow")

					AceConfigDialog:Open("CrosshairOverlay", optFrame)
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
			},
			circleYAxis = {
			  name = "Y Axis",
			  desc = "Calibrate the y axis",
			  type = "range",
			  min = -500,
			  max = 500,
			  softMin = 35,
			  softMax = 500,
			  set = function(info,val)
						CrosshairOverlay.db.profile.themeSettings.crosshairYAxis = val
						CrosshairOverlay:SetYAxis(val)
					end,
			  get = function(info) return CrosshairOverlay.db.profile.themeSettings.crosshairYAxis end
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