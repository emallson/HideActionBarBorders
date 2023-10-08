local name = ...
local bars = {
    "Action",
    "MultiBarBottomLeft",
    "MultiBarBottomRight",
    "MultiBarLeft",
    "MultiBarRight",
    "MultiBar5",
    "MultiBar6",
    "MultiBar7",
    "PetAction",
    "Stance",
}

local function ButtonCount(bar)
    if bar == "PetAction" or bar == "Stance" then
        return 10
    else
        return 12
    end
end

local function HideBorder(button)
    button.NormalTexture:Hide()
    button.icon:RemoveMaskTexture(button.IconMask)
end

local replacementTexture = "interface/addons/HideActionBarBorders/resources/uiactionbar2x"


local replacementAtlas = {
    ["UI-HUD-ActionBar-IconFrame-Slot"]={64, 31, 0.701172, 0.951172, 0.102051, 0.162598, false, false, "2x"},
    ["UI-HUD-ActionBar-IconFrame"]={46, 22, 0.701172, 0.880859, 0.316895, 0.36084, false, false, "2x"},
    ["UI-HUD-ActionBar-IconFrame-AddRow"]={51, 25, 0.701172, 0.900391, 0.215332, 0.265137, false, false, "2x"},
    ["UI-HUD-ActionBar-IconFrame-Down"]={46, 22, 0.701172, 0.880859, 0.430176, 0.474121, false, false, "2x"},
    ["UI-HUD-ActionBar-IconFrame-Flash"]={46, 22, 0.701172, 0.880859, 0.475098, 0.519043, false, false, "2x"},
    ["UI-HUD-ActionBar-IconFrame-FlyoutBorderShadow"]={52, 26, 0.701172, 0.904297, 0.163574, 0.214355, false, false, "2x"},
    ["UI-HUD-ActionBar-IconFrame-Mouseover"]={46, 22, 0.701172, 0.880859, 0.52002, 0.563965, false, false, "2x"},
    ["UI-HUD-ActionBar-IconFrame-Border"]={46, 22, 0.701172, 0.880859, 0.361816, 0.405762, false, false, "2x"},
    ["UI-HUD-ActionBar-IconFrame-AddRow-Down"]={51, 25, 0.701172, 0.900391, 0.266113, 0.315918, false, false, "2x"},
}

local function RemapTexture(texture, replacementTexture)
    local atlasId = texture:GetAtlas()
    local atlas = replacementAtlas[atlasId]

    -- don't even attempt to remap if the atlas is missing
    if atlas == nil then
        return
    end

    local width = texture:GetWidth()
    local height = texture:GetHeight()
    texture:SetTexture(replacementTexture)
    texture:SetTexCoord(atlas[3], atlas[4], atlas[5], atlas[6])
    texture:SetWidth(width)
    texture:SetHeight(height)
end

local function AdjustButtonOverlays(button)
    button.cooldown:SetAllPoints(button)
    RemapTexture(button.HighlightTexture, replacementTexture)
    RemapTexture(button.CheckedTexture, replacementTexture)
    RemapTexture(button.SpellHighlightTexture, replacementTexture)
    RemapTexture(button.NewActionTexture, replacementTexture)
    RemapTexture(button.PushedTexture, replacementTexture)
    RemapTexture(button.Border, replacementTexture)

    button.SlotBackground:SetDrawLayer("BACKGROUND", -1)

    local animFrame = button.SpellCastAnimFrame
    local interruptFrame = button.InterruptDisplay
    animFrame:SetScript("OnShow", function(self) self:Hide() end)
    interruptFrame:SetScript("OnShow", function(self) self:Hide() end)
end

local function HideSelf(self)
    self:Hide()
end

local function setup()
    for _, bar in ipairs(bars) do
        for i = 1,ButtonCount(bar) do
            local key = bar .. "Button" .. i
            local button = _G[key]
            if button ~= nil then
                HideBorder(button)
                button:HookScript('OnShow', HideBorder)
                AdjustButtonOverlays(button)
                button.NormalTexture:HookScript("OnShow", HideSelf)
            else
                print("Missing expected button: " .. key)
            end
        end
    end
end

local frame = CreateFrame("Frame")

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function()
    setup()
end)