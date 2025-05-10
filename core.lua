local ADDON_NAME, _ = ...
UnlimitedPowerPriority = UnlimitedPowerPriority or {}
UnlimitedPowerPriority.priorityList = UnlimitedPowerPriority.priorityList or {}

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

    UnlimitedPowerPriority:Log("Running CMD handlers")
    local handler = UnlimitedPowerPriority.handlers[msg]
    if handler then
        handler()
    else
        UnlimitedPowerPriority.handlers["help"]()
    end
end
