-- Storage array for options
local config = {
    keyBind   = nil,
    checkBox  = nil,
    textEntry = nil,
    multiBox  = nil,
    comboBox  = nil,
    colorPick = nil,
    slider    = nil,
    button    = nil
}

-- Settings are saved at: Zomboid\Lua\modOptions.ini
local function STDTConfig() 
    -- Creating the options object
    local options = PZAPI.ModOptions:create("SongsToDieTo", "Songs To Die To")

    -- addKeyBind(ID, name, value, _tooltip)
    config.keyBind = options:addKeyBind("stopSong", getText("Stop Death Song"), Keyboard.KEY_J, getText("Bind used to stop currently playing Death Song"))

    -- addComboBox(ID, name, _tooltip)
    config.comboBox = options:addComboBox("playMethod", getText("Songlist Play-Method"), getText("Select between:[single],[random],[sequence]"))
    -- Creating entries
    config.comboBox:addItem(getText("Single"), false) -- getValue(): 1
    config.comboBox:addItem(getText("Random"), true) -- getValue(): 2
    config.comboBox:addItem(getText("Sequence"), false) -- getValue(): 3

    -- addSlider(ID, name, min, max, step, value, _tooltip)
    config.slider = options:addSlider("STDT_Volume",  getText("Volume"), 0, 100, 1, 100, getText("Song Volume"))

end

STDTConfig()

return config