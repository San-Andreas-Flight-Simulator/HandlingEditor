local txd = CreateRuntimeTxd("scaleformui")
local banner = CreateDui("", 270, 151)

CreateRuntimeTextureFromDuiHandle(txd, "menuBanner", GetDuiHandle(banner))
local handlingMenu = UIMenu.New("Handling Editor", "Handling Editor Menu", 25, 25, true, "scaleformui", "menuBanner", 1.0)
handlingMenu:MouseControlsEnabled(false)
handlingMenu:MaxItemsOnScreen(10)

local handlingData = {}

local function toNumber(value)
    return math.floor(tonumber(value) * 1000 + 0.5) / 1000
end

local function constructMenu(handlingData)
    handlingMenu.Items = {}
    for _, v in ipairs(handlingData) do
        if tonumber(v.value) then
            v.value = toNumber(v.value)
        elseif type(v.value) == "vector3" then
            local x, y, z = table.unpack(v.value)
            v.value = string.format("%s, %s, %s", toNumber(x), toNumber(y), toNumber(z))
        end

        -- Use description from config.lua if available
        local description = "Type: ~b~" .. v.type
        for _, param in pairs(handlingVariables) do
            if param.name == v.name then
                description = param.desc
                break
            end
        end

        local button = UIMenuItem.New(v.name, "Type: ~b~"..v.type.."\n"..description)
        button:RightLabel(v.value)
        handlingMenu:AddItem(button)
    end
end

local function split(input, sep)
    local table = {}
    local index = 1
    sep = sep or "%s"
    for str in string.gmatch(input, "([^"..sep.."]+)") do
        table[index] = str
        index = index + 1
    end
    return table
end

local function SetVehicleHandlingData(vehicle, data, value)
    if DoesEntityExist(vehicle) then
        for _, v in pairs(handlingVariables) do
            if v.name == data then
                local int = string.find(data, "n")
                local float = string.find(data, "f")
                local vector3 = string.find(data, "vec")
                if int and int == 1 then
                    SetVehicleHandlingInt(vehicle, "CHandlingData", data, tonumber(value))
                elseif float and float == 1 then
                    SetVehicleHandlingFloat(vehicle, "CHandlingData", data, tonumber(value))
                elseif vector3 and vector3 == 1 then
                    SetVehicleHandlingVector(vehicle, "CHandlingData", data, value)
                else
                    SetVehicleHandlingField(vehicle, "CHandlingData", data, value)
                end
            end
        end
    end
end

local function GetVehicleHandlingData(vehicle)
    local data = {}
    if DoesEntityExist(vehicle) then
        for _, v in pairs(handlingVariables) do
            local int = string.find(v.name, "^n")
            local float = string.find(v.name, "^f")
            local vector3 = string.find(v.name, "^vec")
            if int and int == 1 and GetVehicleHandlingInt(vehicle, "CHandlingData", v.name) then
                table.insert(data, {name = v.name, value = GetVehicleHandlingInt(vehicle, "CHandlingData", v.name), type = "int"})
            elseif float and float == 1 and GetVehicleHandlingFloat(vehicle, "CHandlingData", v.name) then
                table.insert(data, {name = v.name, value = GetVehicleHandlingFloat(vehicle, "CHandlingData", v.name), type = "float"})
            elseif vector3 and vector3 == 1 and GetVehicleHandlingVector(vehicle, "CHandlingData", v.name) then
                table.insert(data, {name = v.name, value = GetVehicleHandlingVector(vehicle, "CHandlingData", v.name), type = "vector3"})
            end
        end
        return data
    end
end

handlingMenu.OnItemSelect = function(_, item, index)
    local selected = handlingData[index]
    if not selected then return end

    AddTextEntry("FMMC_KEY_TIP8", "Enter new ~b~"..selected.name.."~w~ value:")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", selected.value, "", "", "", 128)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end

    local result = GetOnscreenKeyboardResult()
    if result then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if selected.type == "vector3" then
            local x, y, z = table.unpack(split(result, ", "))
            if x and y and z then
                SetVehicleHandlingData(vehicle, selected.name, vector3(tonumber(x), tonumber(y), tonumber(z)))
            end
        else
            SetVehicleHandlingData(vehicle, selected.name, result)
        end
        selected.value = result
        item:RightLabel(result)
    end
end

-- add_ace group.admin command.handling allow
RegisterCommand("handling", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle then
        handlingData = GetVehicleHandlingData(vehicle)
        constructMenu(handlingData)
        handlingMenu:Visible(not handlingMenu:Visible())
    else
        handlingMenu:Visible(false)
    end
end)

RegisterKeyMapping("handling", "Handling Editor Menu", "keyboard", "")
