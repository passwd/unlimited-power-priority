function UnlimitedPowerPriority:CastPowerInfusion()
    print(">> CastPowerInfusion() called")

    local CastSpellByName   = _G.CastSpellByName
    local UnitIsPlayer      = _G.UnitIsPlayer
    local UnitIsConnected   = _G.UnitIsConnected
    local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
    local UnitInRange       = _G.UnitInRange

    if type(CastSpellByName) ~= "function" then
        print(">> CastSpellByName not available. Cannot cast.")
        return
    end

    local spellName = "Power Infusion"

    for name, _ in self:SortedPriorityList() do
        local unit = self:FindUnitByName(name)
        if unit and UnitIsPlayer(unit) and UnitIsConnected(unit)
            and not UnitIsDeadOrGhost(unit) and UnitInRange(unit) then

            CastSpellByName(spellName, unit)
            print("Casting Power Infusion on:", name)
            self:AnnouncePowerInfusion(unit)
            return
        end
    end

    print("No valid target found for Power Infusion.")
end
