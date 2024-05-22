-- local E, L, V, P, G = unpack(ElvUI);
-- local DD = E:NewModule("DungeonDiffBar")
-- local EP = LibStub("LibElvUIPlugin-1.0")

-- local ipairs = ipairs;
-- local format = string.format;

-- -- Profile

-- P["actionbar"]["dungeondiffbar"] = {
-- 	["visible"] = "AUTOMATIC",
-- 	["buttonSize"] = 128
-- }

-- -- Config
-- local function InjectOptions()
-- 	E.Options.args.actionbar.args.dungeonDiff = {
-- 		order = 1000,
-- 		type = "group",
-- 		name = L["Dungeon Difficulty Bar"],
-- 		get = function(info) return E.db.actionbar.dungeondiffbar[info[#info]]; end,
-- 		set = function(info, value) E.db.actionbar.dungeondiffbar[info[#info]] = value; DD:UpdateBar(); end,
-- 		args = {
-- 			visible = {
-- 				order = 1,
-- 				type = "select",
-- 				name = L["Visibility"],
-- 				desc = L["Select how the dungeon difficulty bar will be displayed."],
-- 				values = {
-- 					["HIDE"] = L["Hide"],
-- 					["SHOW"] = L["Show"],
-- 					["AUTOMATIC"] = L["Automatic"]
-- 				}
-- 			},
-- 			buttonSize = {
-- 				order = 2,
-- 				type = "range",
-- 				name = L["Button Size"],
-- 				desc = L["The size of the action button."],
-- 				min = 15, max = 128, step = 1
-- 			}
-- 		}
-- 	}
-- end

-- function DD:UpdateBar(first)
-- 	if(first) then
-- 		self.frame:ClearAllPoints()
-- 		self.frame:SetPoint("CENTER")
-- 	end
	
-- 	local buttonSize = self.db.buttonSize
	
-- 	self.frame:SetSize(buttonSize, buttonSize)

-- 	local button = self.frame.button
-- 	button:SetSize(buttonSize, buttonSize)
-- 	button:ClearAllPoints()
-- 	button:SetPoint("CENTER")
	
-- 	if(self.db.visible == "HIDE") then
-- 		UnregisterStateDriver(self.frame, "visibility")
-- 		if(self.frame:IsShown()) then
-- 			self.frame:Hide()
-- 		end
-- 	elseif(self.db.visible == "SHOW") then
-- 		UnregisterStateDriver(self.frame, "visibility")
-- 		if(not self.frame:IsShown()) then
-- 			self.frame:Show()
-- 		end
-- 	else
-- 		RegisterStateDriver(self.frame, "visibility", "[noexists,nogroup] hide; show")
-- 	end
-- end

-- function DD:ButtonFactory()
-- 	local button = CreateFrame("Button", "ElvUI_DungeonDiffBarButton", self.frame, "SecureActionButtonTemplate")
-- 	button:SetBackdrop({bgFile = "Interface\\BUTTONS\\WHITE8X8"})
-- 	button:SetBackdropColor(0, 0, 0, 0.5)
-- 	button:SetNormalTexture("Interface\\Icons\\INV_Misc_QuestionMark")

-- 	button:SetAttribute("type1", "macro")
-- 	button:SetAttribute("macrotext1", "/run print('Dungeon Difficulty Button')")

-- 	button:SetScript("OnEnter", function(self)
-- 		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
-- 		GameTooltip:AddLine("Click to test.", 1, 1, 1)
-- 		GameTooltip:Show()
-- 	end)
-- 	button:SetScript("OnLeave", function() GameTooltip:Hide() end)

-- 	self.frame.button = button
-- end

-- function DD:Initialize()
-- 	self.db = E.db.actionbar.dungeondiffbar

-- 	self.frame = CreateFrame("Frame", "ElvUI_DungeonDiffBar", E.UIParent)
-- 	self.frame:SetPoint("CENTER")
-- 	self.frame:SetResizable(false)
-- 	self.frame:SetClampedToScreen(true)
-- 	self.frame:SetBackdrop({
-- 		bgFile = "Interface\\BUTTONS\\WHITE8X8",
-- 		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
-- 		tile = false, tileSize = 0, edgeSize = 4,
-- 		insets = { left = 0, right = 0, top = 0, bottom = 0 }
-- 	})
-- 	self.frame:SetBackdropColor(0, 0, 0, 0.5)
-- 	self.frame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)

-- 	self:ButtonFactory()
-- 	self:UpdateBar(true)

-- 	E:CreateMover(self.frame, "ElvUI_DDBarMover", L["Dungeon Difficulty Bar"])

-- 	self.frame:SetScript("OnMouseUp", function(_, button)
-- 		if button == "RightButton" then
-- 		    if IsShiftKeyDown() then
-- 			  E:ToggleOptionsUI()
-- 			  LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "actionbar", "dungeonDiff")
-- 		    else
-- 			  E:ToggleOptionsUI()
-- 			  LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "actionbar", "dungeonDiff")
-- 		    end
-- 		end
-- 	end)
-- end

-- E:RegisterModule(DD:GetName())
-- EP:RegisterPlugin("ElvUI_DungeonDiff", InjectOptions)




local E, L, V, P, G = unpack(ElvUI);
local DD = E:NewModule("DungeonDiffBar")
local EP = LibStub("LibElvUIPlugin-1.0")

local ipairs = ipairs;
local format = string.format;

-- Profile

P["actionbar"]["dungeondiffbar"] = {
	["visible"] = "AUTOMATIC",
	["buttonSize"] = 64
}

-- Config
local function InjectOptions()
	E.Options.args.actionbar.args.dungeonDiff = {
		order = 1000,
		type = "group",
		name = L["Dungeon Difficulty Bar"],
		get = function(info) return E.db.actionbar.dungeondiffbar[info[#info]]; end,
		set = function(info, value) E.db.actionbar.dungeondiffbar[info[#info]] = value; DD:UpdateBar(); end,
		args = {
			visible = {
				order = 1,
				type = "select",
				name = L["Visibility"],
				desc = L["Select how the dungeon difficulty bar will be displayed."],
				values = {
					["HIDE"] = L["Hide"],
					["SHOW"] = L["Show"],
					["AUTOMATIC"] = L["Automatic"]
				}
			},
			buttonSize = {
				order = 2,
				type = "range",
				name = L["Button Size"],
				desc = L["The size of the action button."],
				min = 15, max = 128, step = 1
			}
		}
	}
end

local function ClearDifficultyFrames()
    if DD.frame.difficultyFrames then
        for _, f in ipairs(DD.frame.difficultyFrames) do
            f:Hide()
            f:SetParent(nil)
        end
    end
    DD.frame.difficultyFrames = {}
end
 

local function UpdateDungeonDifficulty()
    local _, instanceType, difficultyID = GetInstanceInfo()
    local texturePath = "Interface\\AddOns\\ElvUI_DungeonDiff\\icons\\h" -- Default icon
    local textLabel = "25"
    local button = DD.frame.button

    ClearDifficultyFrames()  -- Очищаем старые фреймы

    if instanceType == "party" then
        if difficultyID == 1 then
            texturePath = "Interface\\AddOns\\ElvUI_DungeonDiff\\icons\\UIDifficulty_Party_Normal"
            textLabel = "5"
 

        elseif difficultyID == 2 then
            texturePath = "Interface\\AddOns\\ElvUI_DungeonDiff\\icons\\UIDifficulty_Party_Heroic"
            textLabel = "Heroic"
        end
    elseif instanceType == "raid" then
        if difficultyID == 1 then
            texturePath = "Interface\\TargetingFrame\\UI-RAIDDIFFICULTY-10MAN"
            textLabel = "10"
        elseif difficultyID == 2 then
            texturePath = "Interface\\TargetingFrame\\UI-RAIDDIFFICULTY-25MAN"
            textLabel = "25"
        elseif difficultyID == 3 then
            texturePath = "Interface\\TargetingFrame\\UI-RAIDDIFFICULTY-10MANHEROIC"
            textLabel = "10H"
        elseif difficultyID == 4 then
            texturePath = "Interface\\TargetingFrame\\UI-RAIDDIFFICULTY-25MANHEROIC"
            textLabel = "25H"
        end
    end

 
    button:SetTexture(texturePath)
    button:SetTexCoord(0.1, 0.9, 0.1, 0.9) -- Обрезаем изображение 

    DD.frame.text:SetText(textLabel) -- Устанавливаем текст
    DD.frame.text:SetTextColor(1, 1, 0, 1) -- Устанавливаем текст
end

function DD:UpdateBar(first)
	if(first) then
		self.frame:ClearAllPoints()
		self.frame:SetPoint("CENTER")
	end
	
	local buttonSize = self.db.buttonSize
	
	self.frame:SetSize(buttonSize, buttonSize)

	local button = self.frame.button
	button:SetSize(buttonSize, buttonSize)
	button:ClearAllPoints()
	button:SetPoint("CENTER")
	
	if(self.db.visible == "HIDE") then
		self.frame:Hide()
	else
		self.frame:Show()
	end

	UpdateDungeonDifficulty()
end

function DD:ButtonFactory()
	local button = self.frame:CreateTexture(nil, "OVERLAY")
	self.frame.button = button

	local text = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text:SetPoint("CENTER", button, "CENTER", 0, 0)
	text:SetTextColor(1, 1, 1, 1) -- Белый цвет текста
	text:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
	self.frame.text = text
end

function DD:Initialize()
	self.db = E.db.actionbar.dungeondiffbar

	self.frame = CreateFrame("Frame", "ElvUI_DungeonDiffBar", E.UIParent)
	self.frame:SetPoint("CENTER")
	self.frame:SetResizable(false)
	self.frame:SetClampedToScreen(true)
	self.frame.difficultyFrames = {}

	self:ButtonFactory()
	self:UpdateBar(true)

	E:CreateMover(self.frame, "ElvUI_DDBarMover", L["Dungeon Difficulty Bar"])

	self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	self.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self.frame:SetScript("OnEvent", UpdateDungeonDifficulty)

	self.frame:SetScript("OnMouseUp", function(_, button)
		if button == "RightButton" then
		    if IsShiftKeyDown() then
			  E:ToggleOptionsUI()
			  LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "actionbar", "dungeonDiff")
		    else
			  E:ToggleOptionsUI()
			  LibStub("AceConfigDialog-3.0-ElvUI"):SelectGroup("ElvUI", "actionbar", "dungeonDiff")
		    end
		end
	end)
end

E:RegisterModule(DD:GetName())
EP:RegisterPlugin("ElvUI_DungeonDiff", InjectOptions)
