local _, addon = ...
CrosshairOverlay.MainFrame = CreateFrame('frame', nil, WorldFrame)
CrosshairOverlay.MainFrame:Hide()
CrosshairOverlay.MainFrame:SetScript("OnEvent", function(self, event)
	if event=="PLAYER_ENTERING_WORLD" then
		-- Entering world
		CrosshairOverlay.MainFrame:Hide()
	elseif event=="PLAYER_REGEN_DISABLED" then
		-- Entering combat
		CrosshairOverlay.MainFrame:Show()
	elseif event=="PLAYER_REGEN_ENABLED" then
		-- Leaving combat
		CrosshairOverlay.MainFrame:Hide()
	elseif event=="CINEMATIC_START" then
		CrosshairOverlay.MainFrame:Hide()
	elseif event=="CINEMATIC_STOP" and InCombatLockdown() then
		CrosshairOverlay.MainFrame:Show()
	end
end)
CrosshairOverlay.MainFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
CrosshairOverlay.MainFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
CrosshairOverlay.MainFrame:SetFrameLevel(0)
CrosshairOverlay.MainFrame:SetFrameStrata('BACKGROUND')
CrosshairOverlay.MainFrame:SetPoint('CENTER', WorldFrame, 0, 35)
CrosshairOverlay.MainFrame:SetSize(16, 16)

function CrosshairOverlay:OnInitialize()
	CrosshairOverlay.db = LibStub("AceDB-3.0"):New("CrosshairOverlayDB", {}, "Default")
	CrosshairOverlay.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	CrosshairOverlay.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	CrosshairOverlay.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	CrosshairOverlay.db:RegisterDefaults({
		global = {
			skins = {},
		},
        profile = {
            enable = true,
			activeSkin = "Circle",
			themeSettings = {}						
        },
    })

	-- Perform skin registrations.
	CrosshairOverlay:SendMessage("CrosshairOverlay:OnRegister")
	
	-- Save registered skins to global
	CrosshairOverlay.db.global.skins = CrosshairOverlay.skins

	CrosshairOverlay:InitializeOptions()
	CrosshairOverlay.optionsframe = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CrosshairOverlay", "Crosshair Overlay")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("CrosshairOverlay", CrosshairOverlay.optionsTable)
	
	CrosshairOverlay:RegisterChatCmd()

	if(CrosshairOverlay.db.profile.enabled) then
		CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnInitialize")
	end

	if(CrosshairOverlay.db.profile.activeSkin ~= "") then
		-- Update the theme settings for this active skin
		CrosshairOverlay:SetActiveThemeSettings(CrosshairOverlay.db.profile.activeSkin)
	end
end

function CrosshairOverlay:OnEnable()
	CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")
end

function CrosshairOverlay:OnDisable()
	CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnDisable")
end

function CrosshairOverlay:RefreshConfig()
	CrosshairOverlay:SendMessage("CrosshairOverlay:OnRefreshConfig")

	-- First disable all skins
	for k, v in pairs(CrosshairOverlay.db.global.skins) do
		CrosshairOverlay:SendMessage("CrosshairOverlay:" .. v .. ":OnDisable")
	end
	
	-- Update the theme settings for this active skin
	CrosshairOverlay:SetActiveThemeSettings(CrosshairOverlay.db.profile.activeSkin)

	-- Enable the chosen skin
	CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")
end