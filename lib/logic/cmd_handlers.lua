UnlimitedPowerPriority.handlers = {
    macro = function()
        UnlimitedPowerPriority:EnsureMacro()
    end,

    config = function()
        UnlimitedPowerPriority:CreateConfigFrame()
        UnlimitedPowerPriority.configFrame:Show()
    end,

    window = function()
        UnlimitedPowerPriority:CreateMainFrame()
        UnlimitedPowerPriority.mainFrame:Show()
        UnlimitedPowerPriority:QueueInspections()
        UnlimitedPowerPriority:RefreshMemberList()
    end,
    minimap = function()
        UnlimitedPowerPriority:ToggleMinimapIcon()
        local state = UnlimitedPowerPriority.db.minimap.hide and "hidden" or "visible"
        UnlimitedPowerPriority:Log("Minimap icon is now", state .. ".")
    end,
    help = function()
        UnlimitedPowerPriority:Log("|cffffd200Unlimited Power Priority Commands:|r")
        UnlimitedPowerPriority:Log("  |cffffff78/upp|r         - Open the target window")
        UnlimitedPowerPriority:Log("  |cffffff78/upp config|r  - Open settings")
        UnlimitedPowerPriority:Log("  |cffffff78/upp macro|r   - Update PI macro")
        UnlimitedPowerPriority:Log("  |cffffff78/upp minimap|r - Toggle minimap icon")
    end
}
