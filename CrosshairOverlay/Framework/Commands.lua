-- Author      : Robert
-- Create Date : 9/8/2017 5:43:48 PM

local function ChatCmd(input)
	if not input or input:trim() == "" then
		LibStub("AceConfigDialog-3.0"):Open("CrosshairOverlay")
		--InterfaceOptionsFrame_OpenToCategory(CrosshairOverlay.optionsframe)
	else
		LibStub("AceConfigCmd-3.0").HandleCommand(CrosshairOverlay, "cro", "CrosshairOverlay", input:trim() ~= "help" and input or "")
	end
end

function CrosshairOverlay:RegisterChatCmd()	
	CrosshairOverlay:RegisterChatCommand("CrosshairOverlay", ChatCmd)
	CrosshairOverlay:RegisterChatCommand("cro", ChatCmd)
end