RegisterNetEvent('rhd_dancegroup:client:mulai', function(emote)
    if source == '' then return end
    if not emote then return end
    ExecuteCommand('e c')
    ClearPedTasksImmediately(cache.ped)
    SetTimeout(500, function() ExecuteCommand('e '..emote) end)
end)

RegisterNetEvent('rhd_dancegroup:client:stop', function()
    if source == '' then return end
    ExecuteCommand('e c')
    ClearPedTasksImmediately(cache.ped)
end)