UnlimitedPowerPriority = {}
UnlimitedPowerPriority.priorityList = {}

local ADDON_NAME, _ = ...
UnlimitedPowerPriority = UnlimitedPowerPriority or {}

SLASH_UNLIMITEDPOWERPRIORITY1 = '/upp'
SlashCmdList["UNLIMITEDPOWERPRIORITY"] = function(msg)
    UnlimitedPowerPriority:CreateMainFrame()
    UnlimitedPowerPriority.mainFrame:Show()
    UnlimitedPowerPriority:QueueInspections()
    UnlimitedPowerPriority:RefreshMemberList()
end

