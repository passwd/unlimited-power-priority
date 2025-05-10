local ADDON_NAME, _ = ...
UnlimitedPowerPriority = UnlimitedPowerPriority or {}
UnlimitedPowerPriority.priorityList = UnlimitedPowerPriority.priorityList or {}



local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, _, addon)
    print(">> ADDON_LOADED fired for:", addon)
    if addon == "UnlimitedPowerPriority" then
        UnlimitedPowerPriority:InitSavedVars()
        UnlimitedPowerPriority:EnsureMacro()
        UnlimitedPowerPriority.initialized = true
    end
end)

SLASH_UNLIMITEDPOWERPRIORITY1 = '/upp'
SlashCmdList["UNLIMITEDPOWERPRIORITY"] = function(msg)
    msg = msg:lower():trim()

    local handler = UnlimitedPowerPriority.handlers[msg]
    if handler then
        handler()
    else
        print("|cffffd200Unlimited Power Priority Commands:|r")
        print("  |cffffff78/upp config|r - Open settings")
        print("  |cffffff78/upp window|r - Toggle main frame")
        print("  |cffffff78/upp execute|r - Cast PI based on the priority list")
    end
end
