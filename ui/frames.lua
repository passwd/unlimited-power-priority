function UnlimitedPowerPriority:CreateMainFrame()
    if self.mainFrame then return end

    local frame = CreateFrame("Frame", "UPP_MainFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(360, 500)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("CENTER", frame.TitleBg, "CENTER", 0, 0)
    frame.title:SetText("Unlimited Power Priority")

    local toolbar = CreateFrame("Frame", nil, frame)
    toolbar:SetSize(260, 30)
    toolbar:SetPoint("TOPLEFT", 10, -28)
    frame.toolbar = toolbar

    -- Rescan Button
    local rescanBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
    rescanBtn:SetSize(100, 22)
    rescanBtn:SetPoint("TOPLEFT", 0, 0)
    rescanBtn:SetText("Rescan")
    rescanBtn.Text:ClearAllPoints()
    rescanBtn.Text:SetPoint("CENTER", 0, -1)
    rescanBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Re-inspect all group members to refresh spec and role icons.")
        GameTooltip:Show()
    end)
    rescanBtn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    rescanBtn:SetScript("OnClick", function()
        UnlimitedPowerPriority:QueueInspections()
        UnlimitedPowerPriority:RefreshMemberList()
    end)

    local optionsBtn = CreateFrame("Button", nil, toolbar, "UIPanelButtonTemplate")
    optionsBtn:SetSize(80, 22)
    optionsBtn:SetPoint("RIGHT", rescanBtn, "RIGHT", 88, 0)
    optionsBtn:SetText("Options")
    optionsBtn:SetScript("OnClick", function()
        UnlimitedPowerPriority:CreateConfigFrame()
        UnlimitedPowerPriority:CreateConfigFrame()
    end)

    -- Create ScrollFrame
    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -65)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(260, 1000) -- height can be arbitrarily large
    scrollFrame:SetScrollChild(content)

    frame.scrollContent = content

    self.mainFrame = frame
end

function UnlimitedPowerPriority:RefreshMemberList()
    if not self.mainFrame or not self.mainFrame.scrollContent then return end

    self:Log("Updating party list...")
    self.unitButtons = {}
    local content = self.mainFrame.scrollContent

    -- Clear previous children
    for _, child in ipairs({ content:GetChildren() }) do
        child:Hide()
    end

    local groupType = IsInRaid() and "raid" or "party"
    local count = GetNumGroupMembers()
    if count == 0 then count = 1 end -- fallback for solo testing

    local rowHeight = 28
    local yOffset = -10

    local units = {}

    -- Build unit list
    for i = 1, count do
        local unit = (groupType == "raid") and "raid" .. i or (i == count and "player" or "party" .. i)
        if UnitExists(unit) then
            table.insert(units, unit)
        end
    end

    for _, unit in ipairs(units) do
        if UnitExists(unit) then
            local name = UnitName(unit)
            local _, class = UnitClass(unit)
            local classColor = RAID_CLASS_COLORS[class] or { r = 1, g = 1, b = 1 }

            local btn = CreateFrame("Button", nil, content)
            btn:SetSize(240, rowHeight)
            btn:SetPoint("TOPLEFT", 0, yOffset)
            yOffset = yOffset - rowHeight - 4

            -- Role icon
            local role = UnitGroupRolesAssigned(unit)
            local roleIcon = btn:CreateTexture(nil, "OVERLAY")
            roleIcon:SetSize(16, 16)
            roleIcon:SetPoint("LEFT", 10, 0)
            if role ~= "NONE" then
                local roleCoords = {
                    PARTY_LEADER = { 0.0000, 0.2859, 0.0000, 0.3359 }, -- 0.0500 subtracted
                    HEALER       = { 0.2859, 0.6218, 0.0000, 0.3359 },
                    TANK         = { 0.0000, 0.2859, 0.3359, 0.6718 },
                    DAMAGER      = { 0.2859, 0.6218, 0.3359, 0.6718 },
                }
                roleIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES")
                if roleCoords[role] then
                    roleIcon:SetTexCoord(unpack(roleCoords[role]))
                    roleIcon:Show()
                else
                    roleIcon:Hide()
                end
            end

            -- Spec icon
            local specIcon = btn:CreateTexture(nil, "OVERLAY")
            specIcon:SetSize(16, 16)
            specIcon:SetPoint("LEFT", roleIcon, "RIGHT", 5, 0)

            local specID
            if unit == "player" then
                specID = GetSpecialization()
                if specID then
                    local _, _, _, icon = GetSpecializationInfo(specID)
                    if icon then
                        specIcon:SetTexture(icon)
                    end
                end
            elseif CanInspect(unit) and not UnitIsUnit(unit, "player") then
                specID = GetInspectSpecialization(unit)
                if specID and specID ~= 0 then
                    local _, _, _, icon = GetSpecializationInfoByID(specID)
                    if icon then
                        specIcon:SetTexture(icon)
                    end
                end
            end

            if not UnitIsPlayer(unit) then
                specIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
            end

            -- Class-colored name
            local nameText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            nameText:SetPoint("LEFT", specIcon, "RIGHT", 5, 0)
            nameText:SetText(name or "Unknown")
            nameText:SetTextColor(classColor.r, classColor.g, classColor.b)

        
            -- Select Target
            local btnHeight = 22
            local selectBtn = self:CreateUnitSelectButton(
                btn, "RIGHT", btnHeight, unit,
                function()
                    self:SelectUnit(unit)
                end,
                function()
                    self:ClearUnit(unit)
                end)

            local ilvlText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            ilvlText:SetPoint("RIGHT", selectBtn, "LEFT", -10, 0)
            ilvlText:SetText("ilvl: .....") -- placeholder

            if UnitIsUnit(unit, "player") then
                local _, equipped = GetAverageItemLevel()
                ilvlText:SetText(string.format("ilvl: %.1f", equipped))
                self.unitIlvlCache[unit] = equipped
            else
                ilvlText:SetText("ilvl: 000.0")
                self:RequestInspectIlvl(unit, ilvlText)
            end

            table.insert(self.unitButtons, selectBtn)
        end
    end

    local contentHeight = math.abs(yOffset) + 10 -- +10 padding at the bottom
    self.mainFrame.scrollContent:SetHeight(contentHeight)
end

function UnlimitedPowerPriority:SelectUnit(uid)
    self.db.spellTarget = uid
    UnlimitedPowerPriority:EnsureMacro()
end

function UnlimitedPowerPriority:ClearUnit(uid)
    self.db.spellTarget = nil
    UnlimitedPowerPriority:EnsureMacro()
end
