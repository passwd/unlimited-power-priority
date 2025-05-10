function UnlimitedPowerPriority:CreateUnitSelectButton(
    parent, anchorPoint, offsetX, unitId, onClickSet, onClickUnset)
    local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate, BackdropTemplate")
    btn:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
    btn:SetSize(80, 22)
    btn:SetPoint("RIGHT", parent, anchorPoint or "RIGHT", offsetX, 0)
    btn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = nil,
        tile = false,
        tileSize = 0,
        edgeSize = 0,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    btn:SetBackdropColor(0, 0, 0, 0)
    btn:GetNormalTexture():SetAlpha(0)
    btn:GetHighlightTexture():SetAlpha(0)

    -- Appearance update function
    local function updateButtonState()
        if self.db.spellTarget == unitId then
            btn:SetText("Targeted")
            btn:SetBackdropColor(0.2, 1.0, 0.2, 0.3) -- light green background
        else
            btn:SetText("Select")
            btn:SetBackdropColor(0, 0, 0, 0) -- transparent
        end
        btn.Text:ClearAllPoints()
        btn.Text:SetPoint("CENTER", 0, -1)
    end

    btn:SetScript("OnEnter", function()
        GameTooltip:SetOwner(btn, "ANCHOR_RIGHT")
        GameTooltip:SetText("Select PI Target")
        GameTooltip:Show()
    end)

    btn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    btn:SetScript("OnClick", function()
        if self.db.spellTarget == unitId then
            self.db.spellTarget = nil
            if onClickUnset then onClickUnset(unitId) end
        else
            self.db.spellTarget = unitId
            if onClickSet then onClickSet(unitId) end
        end
        -- Update all buttons' visual state if you're managing multiple
        if self.UpdateAllUnitButtons then
            self:UpdateAllUnitButtons()
        else
            updateButtonState()
        end
    end)

    -- Initial state
    updateButtonState()

    -- Optional for external refresh
    btn.UpdateState = updateButtonState

    return btn
end

function UnlimitedPowerPriority:UpdateAllUnitButtons()
    for _, btn in ipairs(self.unitButtons or {}) do
        if btn.UpdateState then btn:UpdateState() end
    end
end
