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

    -- Sort units by saved priority
    table.sort(units, function(a, b)
        local nameA = UnitName(a)
        local nameB = UnitName(b)
        local prioA = self.db.priorityList[nameA] or 999
        local prioB = self.db.priorityList[nameB] or 999
        return prioA < prioB
    end)

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


            -- Move Down
            local btnHeight = 22
            local down = self:CreateMoveButton(
                btn, "RIGHT", 80, 60, btnHeight, "Down", "Move down",
                function()
                    self:MoveUnit(unit, 1)
                end)

            -- Move Up
            local up = self:CreateMoveButton(
                down, "LEFT", -2, 40, btnHeight, "Up", "Move Up",
                function()
                    self:MoveUnit(unit, -1)
                end)

            -- Move to Top
            local toTop = self:CreateMoveButton(
                up, "LEFT", -2, 40, btnHeight, "Top", "Move to top",
                function()
                    self:MoveUnitToTop(unit)
                end)
        end
    end

    local contentHeight = math.abs(yOffset) + 10 -- +10 padding at the bottom
    self.mainFrame.scrollContent:SetHeight(contentHeight)
end

-- Moves a unit up or down by 'offset' in the saved priority list
function UnlimitedPowerPriority:MoveUnit(uid, offset)
    local list = {}
    for u, v in pairs(self.db.priorityList or {}) do table.insert(list, { name = u, prio = v }) end
    table.sort(list, function(a, b) return a.prio < b.prio end)
    -- ensure uid in list
    local exists = false
    for _, e in ipairs(list) do if e.name == UnitName(uid) then exists = true end end
    if not exists then table.insert(list, { name = UnitName(uid), prio = #list + 1 }) end
    -- find current index
    local idx
    for i, e in ipairs(list) do
        if e.name == UnitName(uid) then
            idx = i
            break
        end
    end
    local newIdx = idx + offset
    if newIdx >= 1 and newIdx <= #list then
        -- swap
        local other = list[newIdx].name
        self.db.priorityList[UnitName(uid)] = newIdx
        self.db.priorityList[other] = idx
        self:RefreshMemberList()
    end
end

-- Moves a unit directly to the top of the priority list
function UnlimitedPowerPriority:MoveUnitToTop(uid)
    local list = {}
    for u, v in pairs(self.db.priorityList or {}) do table.insert(list, { name = u, prio = v }) end
    table.sort(list, function(a, b) return a.prio < b.prio end)
    -- remove uid from list
    for i, e in ipairs(list) do
        if e.name == UnitName(uid) then
            table.remove(list, i); break
        end
    end
    -- insert at position 1
    table.insert(list, 1, { name = UnitName(uid) })
    -- rebuild priorities
    self.db.priorityList = {}
    for i, e in ipairs(list) do self.db.priorityList[e.name] = i end
    self:RefreshMemberList()
end
