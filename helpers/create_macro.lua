function UnlimitedPowerPriority:EnsureMacro()
    local name = "UPP_CastPI"
    local icon = "Spell_Holy_PowerInfusion"
    local target = (type(self.db.spellTarget) == "string"
            and self.db.spellTarget ~= "")
        and self.db.spellTarget or "focus"

    local target = (type(self.db.spellTarget) == "string" and self.db.spellTarget ~= "")
        and self.db.spellTarget or nil

    local body

    if self.db.useFocusOverride then
        body = "#showtooltip Power Infusion\n"
        body = body .. "/cast [@focus,help,nodead]"
        if target then
            body = body .. "[@" .. target .. ",help,nodead]"
        end
        body = body .. "[@player] Power Infusion"
    else
        body = "#showtooltip Power Infusion\n"
        body = body .. "/cast "
        if target then
            body = body .. "[@" .. target .. ",help,nodead]"
        end
        body = body .. "[@focus,help,nodead][@player] Power Infusion"
    end

    local displayName = UnitExists(target) and UnitName(target) or target


    local existingMacroIndex = GetMacroIndexByName(name)
    if existingMacroIndex == 0 then
        local macroId = CreateMacro(name, icon, body, true)
        if macroId then
            self:Log("PI Macro Created With Target:", displayName)
        else
            self:Log("Failed to create macro: possibly out of macro slots.")
        end
    else
        -- Update existing macro with current target
        EditMacro(existingMacroIndex, name, icon, body)
        self:Log("PI Macro Updated With Target:", displayName)
        self.db.macroCreated = true
    end
end
