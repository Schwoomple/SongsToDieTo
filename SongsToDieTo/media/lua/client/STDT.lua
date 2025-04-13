
local STDT = {}
local config = require("STDToptions")

local songList = {
    "HappyXmas",
    "FoolBelieves"
}

local hasSpawnedOnce = false
local sequenceIndex = 1

function STDT.getVolume()
    local vol = config.slider and config.slider:getValue() or 100
    return vol / 100.0
end

function STDT.getMethod()
    return config.comboBox and config.comboBox:getValue() or 2
end

function STDT.playMusic(player)
    if not player then return end

    local volume = STDT.getVolume()
    local method = STDT.getMethod()
    local song = songList[1]

    if method == 2 then
        song = songList[ZombRand(#songList) + 1]
    elseif method == 3 then
        song = songList[sequenceIndex]
        sequenceIndex = sequenceIndex + 1
        if sequenceIndex > #songList then
            sequenceIndex = 1
        end
    end

    getSoundManager():playMusic(song)
    
    print(string.format("[CORE] Playing Song '%s' at volume %.2f (method: %d)", song, volume, method)) -- Debug test
end

function STDT.stopMusic()
    for _, song in ipairs(songList) do
        getSoundManager():stopMusic(song)
    end

    print("[CORE] Stopping Death Song") -- Debug
end

Events.OnKeyPressed.Add(function(key)
    if config.keyBind and key == config.keyBind:getValue() then
        STDT.stopMusic()
    end
end)

Events.OnPlayerDeath.Add(STDT.playMusic)

if hasSpawnedOnce then
    Events.OnCreatePlayer.Add(STDT.stopMusic)
else
    hasSpawnedOnce = true
end

print("[CORE] Death music script loaded.") -- Console log