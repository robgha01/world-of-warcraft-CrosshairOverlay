CrosshairOverlay = LibStub("AceAddon-3.0"):NewAddon("CrosshairOverlay", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0", "AceSerializer-3.0", "AceHook-3.0");

local alpha = 0.5
local Speed = 10 -- Higher number moves crosshair faster

local _, addon = ...
CrosshairOverlay:MainFrame = CreateFrame('frame', nil, WorldFrame)
CrosshairOverlay:MainFrame:Hide()
CrosshairOverlay:MainFrame:SetScript("OnEvent", function(self, event)
	if event=="PLAYER_ENTERING_WORLD" then
		-- Entering world
		CrosshairOverlay:MainFrame:Hide()
	elseif event=="PLAYER_REGEN_DISABLED" then
		-- Entering combat
		CrosshairOverlay:MainFrame:Show()
	elseif event=="PLAYER_REGEN_ENABLED" then
		-- Leaving combat 
		CrosshairOverlay:MainFrame:Hide()
	elseif event=="CINEMATIC_START" then
		CrosshairOverlay:MainFrame:Hide()
	elseif event=="CINEMATIC_STOP" and InCombatLockdown() then
		CrosshairOverlay:MainFrame:Show()
	end
end)
CrosshairOverlay:MainFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
CrosshairOverlay:MainFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
CrosshairOverlay:MainFrame:SetFrameLevel(0)
CrosshairOverlay:MainFrame:SetFrameStrata('BACKGROUND')
CrosshairOverlay:MainFrame:SetPoint('CENTER', WorldFrame, 0, 35)
CrosshairOverlay:MainFrame:SetSize(16, 16)

function CrosshairOverlay:RefreshConfig()
	AceEvent:SendMessage("CrosshairOverlay:OnRefreshConfig")
	AceEvent:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnInitialize")
end

function CrosshairOverlay:OnInitialize()
	CrosshairOverlay.db = LibStub("AceDB-3.0"):New("CrosshairOverlayDB", {
		profile = {
			enable = true,
			skins = {
			  ['**'] = {
				name = ""				
			  },
			  circle = {
				name = "Circle"
			  },
			}
			activeSkin = "Circle"
		}
	}, true)
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("CrosshairOverlay", CrosshairOverlay.optionsTable)
	
	AceEvent:SendMessage("CrosshairOverlay:OnRegister")
	AceEvent:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnInitialize")
	CrosshairOverlay.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	CrosshairOverlay.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	CrosshairOverlay.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
}
end

function CrosshairOverlay:OnEnable()
	AceEvent:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")
end

function CrosshairOverlay:OnDisable()
	AceEvent:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnDisable")
end