local E, L, V, P, G = unpack(ElvUI)
local DD = E:NewModule("DungeonDiffBar")
local EP = LibStub("LibElvUIPlugin-1.0")

local ipairs = ipairs
local format = string.format

-- Profile
P["actionbar"]["dungeondiffbar"] = {
    ["visible"] = "AUTOMATIC",
    ["buttonSize"] = 42,
    ["textSize"] = 11,
    ["textOffsetX"] = 1,
    ["textOffsetY"] = -7,
    ["textOffsetYN"] = 10 -- дополнительное смещение для иконок типа "n"
}

-- Config
local function InjectOptions()
    E.Options.args.actionbar.args.dungeonDiff = {
        order = 1000,
        type = "group",
        name = L["Dungeon Difficulty Bar"],
        get = function(info) return E.db.actionbar.dungeondiffbar[info[#info]] end,
        set = function(info, value) E.db.actionbar.dungeondiffbar[info[#info]] = value; DD:UpdateBar() end,
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
            },
            textSize = {
                order = 3,
                type = "range",
                name = L["Text Size"],
                desc = L["The size of the text."],
                min = 8, max = 32, step = 1
            },
            textOffsetX = {
                order = 4,
                type = "range",
                name = L["Text Offset X"],
                desc = L["The horizontal offset of the text."],
                min = -50, max = 50, step = 1
            },
            textOffsetY = {
                order = 5,
                type = "range",
                name = L["Text Offset Y"],
                desc = L["The vertical offset of the text."],
                min = -50, max = 50, step = 1
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
    local texturePath = "" -- Default icon
    local textLabel = ""
    local button = DD.frame.button

    ClearDifficultyFrames()  
 

    if instanceType == "party" then
        if difficultyID == 1 then
            texturePath = "Interface\\AddOns\\ElvUI_DungeonDiff\\icons\\n"
            textLabel = "5"
        elseif difficultyID == 2 then
            texturePath = "Interface\\AddOns\\ElvUI_DungeonDiff\\icons\\h"
            textLabel = "5h"
        end
 

        -- Need fix 10/25 not work on 2.4.3 10/25
    elseif instanceType == "raid" then
        if difficultyID == 1 then
            texturePath = "Interface\\AddOns\\ElvUI_DungeonDiff\\icons\\n"
            textLabel = "25"
        elseif difficultyID == 2 then
            texturePath = "Interface\\AddOns\\ElvUI_DungeonDiff\\icons\\n"
            textLabel = "25"
        elseif difficultyID == 3 then
            texturePath = "Interface\\AddOns\\ElvUI_DungeonDiff\\icons\\h"
            textLabel = "10h"
        elseif difficultyID == 4 then
            texturePath = "Interface\\AddOns\\ElvUI_DungeonDiff\\icons\\h"
            textLabel = "25h"
        end
    end

    local textYOffset = E.db.actionbar.dungeondiffbar.textOffsetY
    if texturePath:find("\\n") then
        textYOffset = textYOffset + E.db.actionbar.dungeondiffbar.textOffsetYN
    end

    button:SetTexture(texturePath)
    button:SetTexCoord(0.1, 0.9, 0.1, 0.9) -- Обрезаем изображение

    DD.frame.text:SetText(textLabel) -- Устанавливаем текст
    DD.frame.text:SetTextColor(1, 1, 0, 1) -- Устанавливаем цвет текста
    DD.frame.text:SetFont("Fonts\\FRIZQT__.TTF", DD.db.textSize, "OUTLINE") -- Устанавливаем размер текста
    DD.frame.text:ClearAllPoints()
    DD.frame.text:SetPoint("CENTER", DD.frame.button, "CENTER", DD.db.textOffsetX, textYOffset) -- Устанавливаем позицию текста
end

function DD:UpdateBar(first)
    if first then
        self.frame:ClearAllPoints()
        self.frame:SetPoint("CENTER")
    end

    local buttonSize = self.db.buttonSize

    self.frame:SetSize(buttonSize, buttonSize)

    local button = self.frame.button
    button:SetSize(buttonSize, buttonSize)
    button:ClearAllPoints()
    button:SetPoint("CENTER")

    if self.db.visible == "HIDE" then
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
