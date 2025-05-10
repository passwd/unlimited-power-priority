function UnlimitedPowerPriority:CreateConfigFrame()
    if self.configFrame then
        self.configFrame:Show()
        return
    end

    local frame = CreateFrame("Frame", "UPP_ConfigFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(500, 480)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("CENTER", frame.TitleBg, "CENTER", 0, 0)
    frame.title:SetText("Unlimited Power Priority - Settings")

    local y = -40
    local padding = 20

    local last = self:CreateAnnounceCheckboxes(frame, padding, y)
    last = self:CreateAnnounceInputs(frame, last)
    last = self:ResetAnnounceValues(frame, last)
    last = self:CreateMacroButton(frame, last)
    last = self:CreateConfigActionButton(frame, last)

    frame:SetFrameStrata("DIALOG")
    frame:SetFrameLevel(20) -- Higher than the target window (which can be ~10)

    -- Ensure children like title text and button rows are also bumped up
    for _, region in ipairs({ frame:GetRegions() }) do
        if region.SetDrawLayer then region:SetDrawLayer("OVERLAY") end
        if region.SetFrameLevel then region:SetFrameLevel(21) end
    end

    self.configFrame = frame
end

function UnlimitedPowerPriority:CreateAnnounceCheckboxes(parent, x, y)
    local options = { "Whisper", "Say", "Raid", "Party" }
    self.db.announceTargets = self.db.announceTargets or {}

    local last
    for _, channel in ipairs(options) do
        local cb = CreateFrame("CheckButton", nil, parent, "ChatConfigCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
        cb.Text:SetText("Announce via " .. channel)
        cb:SetChecked(self.db.announceTargets[channel] or false)
        cb:SetScript("OnClick", function(self)
            UnlimitedPowerPriority.db.announceTargets[channel] = self:GetChecked()
        end)
        y = y - 30
        last = cb
    end
    return last
end

function UnlimitedPowerPriority:ResetAnnounceValues(frame, anchor)
    local resetButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    resetButton:SetSize(140, 24)
    resetButton:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)
    resetButton:SetText("Reset to Defaults")

    resetButton:SetScript("OnClick", function()
        -- Wipe saved values
        UnlimitedPowerPriority.db.announceMessages = CopyTable(UnlimitedPowerPriority.DEFAULT_MESSAGES)
        UnlimitedPowerPriority.db.announceTargets = {
            Whisper = false,
            Say = false,
            Raid = false,
            Party = false,
        }

        -- Rebuild the config frame from scratch to reflect reset
        frame:Hide()
        UnlimitedPowerPriority.configFrame = nil
        UnlimitedPowerPriority:CreateConfigFrame()
        UnlimitedPowerPriority.configFrame:Show()
    end)
    return resetButton
end

function UnlimitedPowerPriority:CreateAnnounceInputs(parent, anchor)
    local options = { "Whisper", "Say", "Raid", "Party" }
    self.db.announceMessages = self.db.announceMessages or {}

    local last = anchor
    for _, channel in ipairs(options) do
        local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        label:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -15)
        label:SetText(channel .. " Message:")

        local input = CreateFrame("EditBox", nil, parent, "InputBoxTemplate,BackdropTemplate")
        input:SetSize(440, 20)
        input:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -4)
        input:SetAutoFocus(false)
        input:SetFontObject("ChatFontNormal")
        input:SetJustifyH("LEFT")
        input:SetTextInsets(4, 4, 2, 2)
        input:SetEnabled(true)
        input:EnableMouse(true)
        input:SetTextColor(1, 1, 1, 1)
        input:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true,
            tileSize = 8,
            edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        input:SetBackdropColor(0, 0, 0, 0.5)

        local saved = self.db.announceMessages[channel]
        local default = self.DEFAULT_MESSAGES[channel]
        input:SetText(saved and saved ~= "" and saved or default)

        input:SetScript("OnTextChanged", function(self)
            UnlimitedPowerPriority.db.announceMessages[channel] = self:GetText()
        end)

        last = input
    end

    local note = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    note:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -10)
    note:SetText("Tip: Use |cffffff00{name}|r to include the target’s name.")

    return note
end

function UnlimitedPowerPriority:CreateConfigActionButton(frame)
    local actionButton = CreateFrame("Button", "UPP_ActionButton", frame, "SecureActionButtonTemplate, BackdropTemplate")

    actionButton:SetSize(36, 36)
    actionButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -80, -60)


    local index = GetMacroIndexByName("UPP_CastPI")
    if index > 0 then
        actionButton:SetAttribute("type", "macro")
        actionButton:SetAttribute("macro", index)
    end

    actionButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("Cast Power Infusion on next target.\nDrag to your action bar.")
        GameTooltip:Show()
    end)
    actionButton:SetScript("OnLeave", GameTooltip_Hide)

    actionButton:RegisterForDrag("LeftButton")
    actionButton:SetScript("OnDragStart", function(self)
        local macroIndex = GetMacroIndexByName("UPP_CastPI")
        if macroIndex > 0 then
            PickupMacro(macroIndex)
        else
            self:Log("Macro not found. Use 'Recreate Macro' first.")
        end
    end)

    local icon = actionButton:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\Icons\\Spell_Holy_PowerInfusion")
    icon:SetTexCoord(0, 1, 0, 1)
    icon:SetAllPoints()
    actionButton.icon = icon


    local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("BOTTOM", actionButton, "TOP", 0, 6)
    label:SetText("Drag me to your action bar")

    local openMacroBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    openMacroBtn:SetSize(120, 24)
    openMacroBtn:SetPoint("TOP", actionButton, "BOTTOM", 0, -10)
    openMacroBtn:SetText("Open Macros")
    openMacroBtn:SetScript("OnClick", function()
        ShowMacroFrame()
    end)

    return actionButton
end

function UnlimitedPowerPriority:CreateMacroButton(frame, anchor)
    local recreateButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    recreateButton:SetSize(140, 24)
    recreateButton:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)
    recreateButton:SetText("Recreate Macro")

    recreateButton:SetScript("OnClick", function()
        UnlimitedPowerPriority.db.macroCreated = false
        UnlimitedPowerPriority:EnsureMacro()
    end)
    return recreateButton
end
