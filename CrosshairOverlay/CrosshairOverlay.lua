local alpha = 0.5
local Speed = 10 -- Higher number moves crosshair faster

local _, addon = ...
CrosshairOverlay.MainFrame = CreateFrame('frame', nil, WorldFrame)
CrosshairOverlay.MainFrame:Hide()
CrosshairOverlay.MainFrame:SetScript("OnEvent", function(self, event)
	if event=="PLAYER_ENTERING_WORLD" then
		-- Entering world
		--print("PLAYER_ENTERING_WORLD")
		CrosshairOverlay.MainFrame:Hide()
	elseif event=="PLAYER_REGEN_DISABLED" then
		-- Entering combat
		--print("Entering combat")
		CrosshairOverlay.MainFrame:Show()
	elseif event=="PLAYER_REGEN_ENABLED" then
		-- Leaving combat
		--print("Leaving combat")
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

function CrosshairOverlay:RefreshConfig()
	CrosshairOverlay:SendMessage("CrosshairOverlay:OnRefreshConfig")
	CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnInitialize")
end

function CrosshairOverlay:OnInitialize()
	CrosshairOverlay.db = LibStub("AceDB-3.0"):New("CrosshairOverlayDB", {}, "Default")
	CrosshairOverlay.db:RegisterDefaults({
		global = {
			skins = {},
		},
        profile = {
            enable = true,
			activeSkin = "Circle"			
        },
    })
	
	-- Perform skin registrations.
	CrosshairOverlay:SendMessage("CrosshairOverlay:OnRegister")
	
	-- Save registered skins to global
	CrosshairOverlay.db.global.skins = CrosshairOverlay.skins

	CrosshairOverlay:InitializeOptions()
	CrosshairOverlay.optionsframe = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CrosshairOverlay", "Crosshair Overlay")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("CrosshairOverlay", CrosshairOverlay.optionsTable)
		
	CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnInitialize")
	CrosshairOverlay.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	CrosshairOverlay.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	CrosshairOverlay.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
	CrosshairOverlay:RegisterChatCmd()
	print(CrosshairOverlay.skins)
end

function CrosshairOverlay:OnEnable()
	CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")
end

function CrosshairOverlay:OnDisable()
	CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnDisable")
end