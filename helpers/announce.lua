function UnlimitedPowerPriority:AnnouncePowerInfusion(unit)
    local function formatMessage(template, target)
        return (template or ""):gsub("{name}", UnitName(target) or "?")
    end

    if self.db.announceTargets["Say"] then
        SendChatMessage(formatMessage(self.db.announceMessages.Say, unit), "SAY")
    end

    if self.db.announceTargets["Whisper"] and not UnitIsUnit(unit, "player") then
        SendChatMessage(formatMessage(self.db.announceMessages.Whisper, unit), "WHISPER", nil, UnitName(unit))
    end

    if self.db.announceTargets["Raid"] then
        SendChatMessage(formatMessage(self.db.announceMessages.Raid, unit), "RAID")
    end

    if self.db.announceTargets["Party"] then
        SendChatMessage(formatMessage(self.db.announceMessages.Party, unit), "PARTY")
    end
end
