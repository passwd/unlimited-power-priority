function UnlimitedPowerPriority:EnsureMacro()
    local name = "UPP_CastPI"
    local icon = "Spell_Holy_PowerInfusion"
    local target = (type(self.db.spellTarget) == "string" 
        and self.db.spellTarget ~= "") 
        and self.db.spellTarget or "focus"

    local body = string.format(
        "#showtooltip Power Infusion\n/cast [@%s,help,nodead][@focus,help,nodead][@player] Power Infusion",
        target
    )

    local existingMacroIndex = GetMacroIndexByName(name)
    if existingMacroIndex == 0 then
        local macroId = CreateMacro(name, icon, body, true)
        if macroId then
            self:Log("PI Macro Created:", name)
        else
            self:Log("Failed to create macro: possibly out of macro slots.")
        end
    else
        -- Update existing macro with current target
        EditMacro(existingMacroIndex, name, icon, body)
        self:Log("PI Macro Updated:", name)
        self.db.macroCreated = true
    end
end
