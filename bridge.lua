-- bridge.lua
-- Enhanced bridge with battle menu tracking

local STATE_FILE = "game_state.json"
local INPUT_FILE = "game_input.json"

function get_game_state()
    local sys = emu.getsystemid()
    if sys == "NULL" or sys == "None" then return nil end

    local domains = memory.getmemorydomainlist()
    local has_wram = false
    for _, d in ipairs(domains) do if d == "WRAM" then has_wram = true break end end
    if not has_wram then return nil end

    local state = {
        hp = memory.read_u16_le(0x1609, "WRAM"),
        hp2 = memory.read_u16_le(0x1621, "WRAM"),
        hp3 = memory.read_u16_le(0x1639, "WRAM"),
        in_battle = (memory.readbyte(0x2F35, "WRAM") == 1) or (memory.readbyte(0x3E21, "WRAM") > 0),
        battle_cursor = memory.readbyte(0x2F36, "WRAM"),
        sub_menu = memory.readbyte(0x2F37, "WRAM"),
        map_id = memory.read_u16_le(0x1F64, "WRAM"),
        x = memory.read_u16_le(0x0082, "WRAM"),
        y = memory.read_u16_le(0x0084, "WRAM"),
        window_open = memory.readbyte(0x00AE, "WRAM") > 0,
        frame = emu.framecount()
    }
    return state
end

while true do
    local state = get_game_state()
    if state then
        -- Safe JSON construction
        local fields = {}
        for k, v in pairs(state) do
            if type(v) == "boolean" then
                table.insert(fields, string.format('"%s": %s', k, tostring(v)))
            else
                table.insert(fields, string.format('"%s": %d', k, v))
            end
        end
        local state_json = "{" .. table.concat(fields, ", ") .. "}"
        
        local f = io.open(STATE_FILE, "w")
        if f then f:write(state_json) f:close() end

        local f_in = io.open(INPUT_FILE, "r")
        if f_in then
            local content = f_in:read("*all")
            f_in:close()
            
            local buttons = {}
            local controlled = {"A", "B", "X", "Y", "Up", "Down", "Left", "Right", "Start", "Select", "L", "R"}
            
            if content and content ~= "" then
                for _, btn in ipairs(controlled) do
                    buttons[btn] = string.find(content, '"' .. btn .. '": true') ~= nil
                end
            end
            joypad.set(buttons, 1)
        end
    end
    emu.frameadvance()
end