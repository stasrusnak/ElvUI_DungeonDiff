local E, L, V, P, G = unpack(ElvUI)

local function createOptions()
    E.Options.args.elvuiPlugins.args.difficulty = {
        order = 10,
        type = "group",
        name = "Сложность",
        args = {
            helloText = {
                order = 1,
                type = "description",
                name = "Привет",
            },
        },
    }
end

local function Initialize()
    if E.Options.args.elvuiPlugins then
        createOptions()
    end
end

local function InitializeCallback()
    Initialize()
end

E:RegisterModule("ElvUI_DungeonDiff", InitializeCallback)
