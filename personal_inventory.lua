-- Personal Inventory Script with UI for FiveM
-- Author: asyncflo

local playerInventory = {} -- Speicher für das persönliche Inventar der Spieler
local MAX_ITEMS = 30 -- Maximale Anzahl an Gegenständen
local INVENTORY_KEY = 23 -- "I"-Taste

-- Funktion: Zeige das Inventar-UI
RegisterCommand("inventory", function(source, args, rawCommand)
    local player = GetPlayerPed(-1)

    -- Initialisiere Inventar für den Spieler, falls noch nicht vorhanden
    if not playerInventory[source] then
        playerInventory[source] = {}
    end

    -- Sende das Inventar an das NUI-Frontend
    local items = playerInventory[source]
    SetNuiFocus(true, true) -- UI aktivieren
    SendNUIMessage({
        type = "openInventory",
        items = items,
        maxItems = MAX_ITEMS
    })
end, false)

-- Event: Neues Item hinzufügen
RegisterNUICallback("addItem", function(data, cb)
    local playerId = source
    local items = playerInventory[playerId]

    if #items < MAX_ITEMS then
        table.insert(items, data.itemName)
        cb({ success = true, items = items })
    else
        cb({ success = false, message = "Das Inventar ist voll!" })
    end
end)

-- Event: Item entfernen
RegisterNUICallback("removeItem", function(data, cb)
    local playerId = source
    local items = playerInventory[playerId]

    if #items > 0 then
        table.remove(items, data.itemIndex)
        cb({ success = true, items = items })
    else
        cb({ success = false, message = "Das Inventar ist leer!" })
    end
end)

-- Event: Inventar schließen
RegisterNUICallback("closeInventory", function(data, cb)
    SetNuiFocus(false, false) -- UI deaktivieren
    cb("ok")
end)

-- Taste registrieren
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, INVENTORY_KEY) then
            ExecuteCommand("inventory")
        end
    end
end)
