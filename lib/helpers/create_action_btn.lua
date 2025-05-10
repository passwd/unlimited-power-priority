function UnlimitedPowerPriority:CreateActionButton()
    local btn = CreateFrame("Button", "UPP_ActionButton", UIParent, "SecureActionButtonTemplate, ActionButtonTemplate")
    btn:SetSize(36, 36)
    btn:SetPoint("CENTER", UIParent, "CENTER", 200, 0) -- arbitrary position, movable if you want
    btn:SetAttribute("type", "macro")
    btn:SetAttribute("macrotext", "/click UPP_VirtualCastButton")
    btn.icon:SetTexture("Interface\\Icons\\Spell_Holy_PowerInfusion")

    -- You could show it only in config mode or make it draggable
    btn:Show()
end