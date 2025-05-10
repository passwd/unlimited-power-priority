function UnlimitedPowerPriority:SortedPriorityList()
    local list = {}
    for name, prio in pairs(self.db.priorityList or {}) do
        table.insert(list, { name = name, prio = prio })
    end
    table.sort(list, function(a, b) return a.prio < b.prio end)
    return coroutine.wrap(function()
        for _, entry in ipairs(list) do
            coroutine.yield(entry.name, entry.prio)
        end
    end)
end