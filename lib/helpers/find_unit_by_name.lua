function UnlimitedPowerPriority:FindUnitByName(targetName)
    local groupType = IsInRaid() and "raid" or "party"
    local count = GetNumGroupMembers()
    if count == 0 then return "player" end

    for i = 1, count do
        local unit = (groupType == "raid") and ("raid" .. i) or ((i == count and "player") or "party" .. i)
        if UnitName(unit) == targetName then
            return unit
        end
    end
end