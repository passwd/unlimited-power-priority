local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")

f:SetScript("OnEvent", function(self, event, ...)
    UnlimitedPowerPriority:InitSavedVars()
end)

function UnlimitedPowerPriority:InitSavedVars()
    UPP_Saved = UPP_Saved or {}
    self.db = UPP_Saved

    -- Init default structures
    self.db.spellTarget = self.db.spellTarget or ""
    self.db.settings = self.db.settings or {}
    self.db.announceTargets = self.db.announceTargets or {}
    self.db.announceMessages = self.db.announceMessages or {}
    self.db.macroCreated = self.db.macroCreated or false
end

function UnlimitedPowerPriority:QueueInspections()
    self.inspectQueue = {}

    local groupType = IsInRaid() and "raid" or "party"
    local count = GetNumGroupMembers()
    if count == 0 then count = 1 end

    for i = 1, count do
        local unit = (groupType == "raid") and "raid" .. i or (i == count and "player" or "party" .. i)
        if UnitIsPlayer(unit) and CanInspect(unit) then
            table.insert(self.inspectQueue, unit)
        end
    end

    self:StartNextInspection()
end

function UnlimitedPowerPriority:StartNextInspection()
    if not self.inspectQueue or #self.inspectQueue == 0 then return end

    local nextUnit = table.remove(self.inspectQueue, 1)
    if UnitExists(nextUnit) and CanInspect(nextUnit) then
        NotifyInspect(nextUnit)
    end

    C_Timer.After(1.2, function()
        self:StartNextInspection()
    end)
end
