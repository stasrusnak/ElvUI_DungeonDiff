-- English
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "enUS", true)

if not L then return end 
	L["Automatic"] = true
	L["Visibility"] = true
	L["Select how the dungeon difficulty bar will be displayed."] = true
	L["Hide"] = true
	L["Show"] = true
	L["Dungeon Difficulty Bar"] = true
	L["Button Size"] = true
	L["The size of the action button."] = true
	L["Text Size"] = true
	L["The size of the text."] = true
	L["Text Offset X"] = true
	L["The horizontal offset of the text."] = true
	L["Text Offset Y"] = true
	L["The vertical offset of the text."] = true 
if GetLocale() == "enUS" then return end

-- Russian
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "ruRU")
if L then
    L["Automatic"] = "Автоматически"
    L["Visibility"] = "Видимость"
    L["Select how the dungeon difficulty bar will be displayed."] = "Выберите, как будет отображаться панель сложности подземелья."
    L["Hide"] = "Скрыть"
    L["Show"] = "Показать"
    L["Dungeon Difficulty Bar"] = "Панель Dungeon Difficulty"
    L["Button Size"] = "Размер кнопки"
    L["The size of the action button."] = "Размер кнопки действия."
    L["Text Size"] = "Размер текста"
    L["The size of the text."] = "Размер текста."
    L["Text Offset X"] = "Смещение текста по X"
    L["The horizontal offset of the text."] = "Горизонтальное смещение текста."
    L["Text Offset Y"] = "Смещение текста по Y"
    L["The vertical offset of the text."] = "Вертикальное смещение текста."
end