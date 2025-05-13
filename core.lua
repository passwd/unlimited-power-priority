local ADDON_NAME, _ = ...
UnlimitedPowerPriority = UnlimitedPowerPriority or {}
UnlimitedPowerPriority.priorityList = UnlimitedPowerPriority.priorityList or {}

if select(2, UnitClass("player")) ~= "PRIEST" then
    return -- Do not load the addon if not a priest
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, _, addon)
    if addon == "UnlimitedPowerPriority" then
        UnlimitedPowerPriority:InitSavedVars()
        UnlimitedPowerPriority:EnsureMacro()
        UnlimitedPowerPriority:RegisterCastNotificationHook()
        UnlimitedPowerPriority:CreateMinimapIcon()
        UnlimitedPowerPriority.initialized = true
    end
end)

SLASH_UNLIMITEDPOWERPRIORITY1 = '/upp'
SlashCmdList["UNLIMITEDPOWERPRIORITY"] = function(msg)
    msg = msg:lower():trim()
    msg = msg ~= "" and msg or "window"

    if InCombatLockdown() and msg ~= "help" then
        UnlimitedPowerPriority:Log("This command cannot be used during combat.")
        return
    end
    
    local handler = UnlimitedPowerPriority.handlers[msg]
    if handler then
        handler()
    else
        UnlimitedPowerPriority.handlers["help"]()
    end
end

-- Register INSPECT_READY to handle ilvl fetches
UnlimitedPowerPriority.inspectFrame = CreateFrame("Frame")
UnlimitedPowerPriority.inspectFrame:RegisterEvent("INSPECT_READY")
UnlimitedPowerPriority.inspectFrame:SetScript("OnEvent", function(_, _, guid)
    local request = UnlimitedPowerPriority.inspectRequests and UnlimitedPowerPriority.inspectRequests[guid]
    if request and request.unit and request.font then
        local ilvl = C_PaperDollInfo.GetInspectItemLevel(request.unit)
        if ilvl then
            UnlimitedPowerPriority.unitIlvlCache[request.unit] = ilvl
            request.font:SetText(string.format("ilvl: %.1f", ilvl))
        else
            request.font:SetText("ilvl: ???")
        end
        UnlimitedPowerPriority.inspectRequests[guid] = nil
    end
end)