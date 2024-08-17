lib.addCommand('playEmoteRadius', {
    help = 'Untuk menjalankan emote pada semua pemain yang berada di radius yang sudah di tetapkan.',
    params = {
        {
            name = 'emote',
            type = 'string',
            help = 'Nama emote nya'
        },
        {
            name = 'radius',
            type = 'number',
            help = 'Radius nya (max 50)',
        },
    },
}, function(source, args, raw)
    local myPed = GetPlayerPed(source)
    local myCoords = GetEntityCoords(myPed)

    local players = GetPlayers()

    if args.radius > 50 then
        args.radius = 50
    end


    for i=1, #players do
        local id = players[i]
        local ped = GetPlayerPed(id)
        local coords = GetEntityCoords(ped)
        local dist = #(coords - myCoords)

        if dist < args.radius then
            Player(id).state:set('prepare_emote', args.emote, true)
        end
    end

    TriggerClientEvent('client:syncEmote', -1)
end)