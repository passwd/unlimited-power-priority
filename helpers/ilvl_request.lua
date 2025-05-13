function UnlimitedPowerPriority:RequestInspectIlvl(unit, targetFont)
    if InCombatLockdown() or not CanInspect(unit) or not UnitIsConnected(unit) then return end

    local guid = UnitGUID(unit)
    self.inspectRequests = self.inspectRequests or {}
    self.inspectRequests[guid] = { unit = unit, font = targetFont }

    NotifyInspect(unit)
end