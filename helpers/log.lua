function UnlimitedPowerPriority:Log(...)
    local msg = string.join(" ", tostringall(...))
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[UPP]|r " .. msg)
end
