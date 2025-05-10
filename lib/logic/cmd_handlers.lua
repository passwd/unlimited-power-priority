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
    help = function()
        UnlimitedPowerPriority:Log("|cffffd200Unlimited Power Priority Commands:|r")
        UnlimitedPowerPriority:Log("  |cffffff78/upp config|r - Open settings")
        UnlimitedPowerPriority:Log("  |cffffff78/upp window|r - Toggle main frame")
        UnlimitedPowerPriority:Log("  |cffffff78/upp macro|r  - Update PI macro")
    end
}
