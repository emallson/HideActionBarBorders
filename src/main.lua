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
    button.IconMask:Hide()
end

local function AdjustButtonOverlays(button)
    button.cooldown:SetAllPoints(button)
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

-- this addresses a race condition with applying the above to the default action bar. 
-- naively calling `setup` frequently causes the borders to be hidden on all bars *except* the main bar.
C_Timer.After(0, setup)
