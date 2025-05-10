function UnlimitedPowerPriority:CreateMinimapIcon()
    local LDB = LibStub("LibDataBroker-1.1")
    local icon = LibStub("LibDBIcon-1.0")
    self:Log("Loading minimap icon")

    self.minimapIcon = LDB:NewDataObject("UnlimitedPowerPriority", {
        type = "launcher",
        text = "Unlimited Power Priority",
        icon = "Interface\\Icons\\Spell_Holy_PowerInfusion",

        OnClick = function(_, button)
            if button == "LeftButton" then
                UnlimitedPowerPriority.handlers["window"]()
            elseif button == "RightButton" then
                UnlimitedPowerPriority.handlers["config"]()
            end
        end,

        OnTooltipShow = function(tt)
            tt:AddLine("Unlimited Power Priority")
            tt:AddLine("Left-click: Toggle Target Window")
            tt:AddLine("Right-click: Open Settings")
        end,
    })

    self.db.minimap = self.db.minimap or { hide = false }
    LibStub("LibDBIcon-1.0"):Register("UnlimitedPowerPriority", self.minimapIcon, self.db.minimap)
end

function UnlimitedPowerPriority:ToggleMinimapIcon()
    local icon = LibStub("LibDBIcon-1.0")
    if self.db.minimap.hide then
        icon:Show("UnlimitedPowerPriority")
        self.db.minimap.hide = false
    else
        icon:Hide("UnlimitedPowerPriority")
        self.db.minimap.hide = true
    end
end