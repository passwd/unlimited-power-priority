    UnlimitedPowerPriority.handlers = {
        cast = function()
            UnlimitedPowerPriority:CastPowerInfusion()
        end,

        config = function()
            UnlimitedPowerPriority:CreateConfigFrame()
            UnlimitedPowerPriority.configFrame:Show()
        end,

        window = function()
            if not UnlimitedPowerPriority.initialized then
                print("Unlimited Power Priority is still loading. Please try again.")
                return
            end

            UnlimitedPowerPriority:CreateMainFrame()
            if UnlimitedPowerPriority.mainFrame:IsShown() then
                UnlimitedPowerPriority.mainFrame:Hide()
            else
                UnlimitedPowerPriority.mainFrame:Show()
                UnlimitedPowerPriority:QueueInspections()
                UnlimitedPowerPriority:RefreshMemberList()
            end
        end,
    }