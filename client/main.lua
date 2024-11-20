RegisterNetEvent('rhd_syncAnimation:client:syncEmote', function(emote)
    if not emote then return end
    ExecuteCommand('e '..emote)
end)