function UnlimitedPowerPriority:CreateMoveButton(
    parent, anchorPoint, offsetX, width, height, text, tooltip, onClick)
    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    btn:SetSize(width, height)
    btn:SetPoint("RIGHT", parent, anchorPoint or "RIGHT", offsetX, 0)
    btn:SetText(text)
    btn.Text:ClearAllPoints()
    btn.Text:SetPoint("CENTER", 0, -1)
    
    btn:SetScript("OnEnter", function()
        if tooltip then
            GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
            GameTooltip:SetText(tooltip)
            GameTooltip:Show()
        end
    end)

    btn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    if onClick then
        btn:SetScript("OnClick", onClick)
    end

    return btn
end
