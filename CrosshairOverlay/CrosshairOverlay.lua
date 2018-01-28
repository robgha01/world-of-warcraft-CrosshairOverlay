local _, addon = ...
local dbg = {}

-- create a debug window and hide it.
local frame = CreateFrame("Frame","MyCrosshairOverlayDebugFrame",UIParent,"BasicFrameTemplate")
frame:SetSize(300,400)
frame:SetPoint("CENTER", 0, -50)
frame:Hide()

-- makes the frame movable
frame:SetMovable(true);
frame:EnableMouse(true);
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- create scrollable editbox with default "InputScrollFrameTemplate" template
frame.scrollFrame = CreateFrame("ScrollFrame","MyCrosshairOverlayDebugScrollFrame",frame,"InputScrollFrameTemplate")
frame.scrollFrame:SetPoint("TOPLEFT",8,-30)
frame.scrollFrame:SetPoint("BOTTOMRIGHT",-12,9)

-- set up the editbox defined above
local editBox = frame.scrollFrame.EditBox -- already created in above template
editBox:SetFontObject("ChatFontNormal")
editBox:SetAllPoints(true)
editBox:SetWidth(frame.scrollFrame:GetWidth()) -- multiline editboxes need a width declared!!
editBox:SetFont("Fonts\\FRIZQT__.TTF", 11);
editBox:SetMultiLine(true);
editBox:SetMaxLetters(0);

-- when ESC is hit while editbox has focus, clear focus (a second ESC closes window)
editBox:SetScript("OnEscapePressed",editBox.ClearFocus)

-- set up the char count defined above
frame.scrollFrame.CharCount:Hide()

function CrosshairOverlay:AddDebug(msg)
	if CrosshairOverlay.db.profile.debug then
		tinsert(dbg, tostring(msg))

		if not frame:IsVisible() then
			frame:Show()
		end

		if not editBox:IsVisible() then
			editBox:Show()
		end

		-- send them to editbox
		editBox:SetText(table.concat(dbg,"\n"))
	end
end

function CrosshairOverlay:AddDebug(key, msg)
	if CrosshairOverlay.db.profile.debug then
		tinsert(dbg, key..": "..tostring(msg))

		if not frame:IsVisible() then
			frame:Show()
		end

		if not editBox:IsVisible() then
			editBox:Show()
		end

		-- send them to editbox
		editBox:SetText(table.concat(dbg,"\n"))
	end
end

function CrosshairOverlay:ClearDebug()
	if CrosshairOverlay.db.profile.debug then
		-- clear any data
		dbg = {}

		-- add title
		tinsert(dbg, "Crosshair Overlay - Debugger")
		tinsert(dbg, "------------------------")
		tinsert(dbg, "")
		editBox:SetText(table.concat(dbg,"\n"))
	end
end

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
			debug = false,
			activeSkin = "Circle",
			themeSettings = {}						
        },
    })

	-- Perform skin registrations.
	CrosshairOverlay:SendMessage("CrosshairOverlay:OnRegister")
	
	-- Save registered skins to global
	CrosshairOverlay.db.global.skins = CrosshairOverlay.skins

	CrosshairOverlay:InitializeOptions()
	CrosshairOverlay.optionsframe = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Configure", "Crosshair Overlay")
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Configure", CrosshairOverlay.blizOptionsTable)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("CrosshairOverlay", CrosshairOverlay.optionsTable)
	
	CrosshairOverlay:RegisterChatCmd()

	CrosshairOverlay:AddDebug("Enabled", CrosshairOverlay.db.profile.enabled)
	CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnInitialize")

	if(CrosshairOverlay.db.profile.activeSkin ~= "") then
		-- Update the theme settings for this active skin
		CrosshairOverlay:SetActiveThemeSettings(CrosshairOverlay.db.profile.activeSkin)
		CrosshairOverlay:AddDebug("active skin", CrosshairOverlay.db.profile.activeSkin)
	end
end

function CrosshairOverlay:OnEnable()
	if CrosshairOverlay.db.profile.enabled then
		CrosshairOverlay:AddDebug("Event", "CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")
		CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")
	end
end

function CrosshairOverlay:OnDisable()
	if CrosshairOverlay.db.profile.enabled == false then
		CrosshairOverlay:AddDebug("Event", "CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnDisable")
		CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnDisable")
	end
end

function CrosshairOverlay:RefreshConfig()
	CrosshairOverlay:AddDebug("Reverting any changes made by a skin to default")
	CrosshairOverlay:RevertChanges()

	CrosshairOverlay:AddDebug("Event", "OnRefreshConfig")
	CrosshairOverlay:SendMessage("CrosshairOverlay:OnRefreshConfig")

	-- First disable all skins
	for k, v in pairs(CrosshairOverlay.db.global.skins) do
		CrosshairOverlay:AddDebug("Event", "CrosshairOverlay:" .. v .. ":OnDisable")
		CrosshairOverlay:SendMessage("CrosshairOverlay:" .. v .. ":OnDisable")
	end
	
	-- Update the theme settings for this active skin
	CrosshairOverlay:AddDebug("Set active theme from settings", CrosshairOverlay.db.profile.activeSkin)
	CrosshairOverlay:SetActiveThemeSettings(CrosshairOverlay.db.profile.activeSkin)

	-- Enable the chosen skin
	CrosshairOverlay:AddDebug("Event", "CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")
	CrosshairOverlay:SendMessage("CrosshairOverlay:" .. CrosshairOverlay.db.profile.activeSkin .. ":OnEnable")
end