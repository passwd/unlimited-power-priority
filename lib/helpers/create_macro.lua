function UnlimitedPowerPriority:EnsureMacro()
    print("EnsureMacro() running")
    if self.db.macroCreated then 
        print("Macro exists")
        return
    end

    local name = "UPP_CastPI"
    local icon = "Spell_Holy_PowerInfusion"
    local body = "#showtooltip Power Infusion\n/upp cast"

    if GetMacroIndexByName(name) == 0 then
        local macroId = CreateMacro(name, icon, body, true)
        if macroId then
            print("Created macro:", name)
            self.db.macroCreated = true
        else
            print("Failed to create macro: possibly out of macro slots.")
        end
    else
        -- Macro already exists but wasn't created by us
        self.db.macroCreated = true
    end
end
