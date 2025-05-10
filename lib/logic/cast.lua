function UnlimitedPowerPriority:RegisterCastNotificationHook()
    if self.castNotificationFrame then return end

    local POWER_INFUSION_ID = 10060

    local f = CreateFrame("Frame")
    f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

    f:SetScript("OnEvent", function(_, _, unit, _, spellID)
        if unit ~= "player" or spellID ~= POWER_INFUSION_ID then return end

        local primary = self.db.spellTarget
        local fallback = "focus"
        local usedTarget

        -- Check if the primary target is valid
        if primary and UnitExists(primary) and UnitIsFriend("player", primary) and not UnitIsDeadOrGhost(primary) then
            usedTarget = primary
        elseif UnitExists(fallback) and UnitIsFriend("player", fallback) and not UnitIsDeadOrGhost(fallback) then
            usedTarget = fallback
        end

        if usedTarget then
            self:AnnouncePowerInfusion(usedTarget)

            if usedTarget == fallback then
                self:Log("UPP: Power Infusion cast on fallback (focus) instead of selected target.")
            end
        else
            self:Log("UPP: Power Infusion cast, but no valid target found.")
        end
    end)

    self.castNotificationFrame = f
end
