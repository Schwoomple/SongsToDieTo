
local STDT = {}
local config = require("STDToptions")

-- Grabs songs from STDT_Sounds.txt given their name
local songList = {
    "HappyXmas",
    "FoolBelieves",
    "ODST"
}

local hasSpawnedOnce = {}
local sequenceIndex = 1

-- Functionally does nothing as of now.
function STDT.getVolume()
    local vol = config.slider and config.slider:getValue() or 100
    return vol / 100.0
end

-- Finds which method is selected in options.
function STDT.getMethod()
    return config.comboBox and config.comboBox:getValue() or 2
end

-- Plays Music
function STDT.playMusic(player)
    if not player then return end

    local volume = STDT.getVolume() -- nonfunctional
    local method = STDT.getMethod() -- putting method type in variable (1,2,or 3)
    local song = songList[1]

    -- if none of these apply, pick method 1 and only play song[1]
    if method == 2 then                                 -- 2 = randomized song choice
        song = songList[ZombRand(#songList) + 1] 
    elseif method == 3 then                             -- 3 = sequential song choice starting with [1]
        song = songList[sequenceIndex]
        sequenceIndex = sequenceIndex + 1
        if sequenceIndex > #songList then
            sequenceIndex = 1
        end
    end

    getSoundManager():playMusic(song)
    
    print(string.format("[CORE] Playing Song '%s' at volume %.2f (method: %d)", song, volume, method)) -- Debugging
end

function STDT.stopMusic()
    for _, song in ipairs(songList) do
        getSoundManager():stopMusic(song)
    end

    print("[CORE] Stopping Death Song") -- Debugging
end

-- Allows user to stop song whenever they want.
Events.OnKeyPressed.Add(function(key)
    if config.keyBind and key == config.keyBind:getValue() then
        STDT.stopMusic()
    end
end)

Events.OnPlayerDeath.Add(STDT.playMusic) -- hooks into death event and plays music

-- Only stops song IF the player dies atleast once and not on first creation(to avoid premature initialization)
Events.OnCreatePlayer.Add(function(playerIndex, player)
    print("[CORE] OnCreatePlayer triggered for playerIndex: " .. playerIndex) -- Debugging
    if hasSpawnedOnce[playerIndex] then
        print("[CORE] Player " .. playerIndex .. " already spawned once. Stopping music.") -- Debugging
        STDT.stopMusic()
    else
        print("[CORE] Player " .. playerIndex .. " first time spawning.") -- Debugging
        hasSpawnedOnce[playerIndex] = true
    end
end)

print("[CORE] Death music script loaded.") -- Console logging