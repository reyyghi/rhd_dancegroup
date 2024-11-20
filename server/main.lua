local emoteSession = {}
local alreadyInSession = {}
local table_type = table.type

local function removeFromSession(source, sesiId)
    local sesiData = emoteSession[sesiId]

    if not sesiData or
        type(sesiData) ~= 'table' or
        table.type(sesiData) ~= 'array'
    then
        return
    end

    for i=1, #sesiData do
        local src = sesiData[i]
        if src == source then
            emoteSession[sesiId][i] = nil
            alreadyInSession[src] = nil
            break
        end
    end
end

lib.addCommand('buatsesiemote', {
    help = 'Membuat session emote',
}, function (source)
    if emoteSession[source] then
        return lib.notify(source, {
            description = 'Sesi emote anda sudah ada!',
            type = 'error'
        })
    end

    emoteSession[source] = {
        source
    }

    alreadyInSession[source] = source

    lib.notify(source, {
        description = 'Berhasil membuat sesi emote',
        type = 'success'
    })
end)

lib.addCommand('resetsesiemote', {
    help = 'Reset session emote',
}, function (source)

    if alreadyInSession[source] and not emoteSession[source] then
        removeFromSession(source)
        return  lib.notify(source, {
            description = 'Sesi emote berhasil di reset!',
            type = 'success'
        })
    end

    if not emoteSession[source] then
        return lib.notify(source, {
            description = 'Kamu belum pernah membuat sesi emote!',
            type = 'error'
        })
    end

    for i=1, #emoteSession[source] do
        local memberSource = emoteSession[source][i]
        alreadyInSession[memberSource] = nil
    end

    emoteSession[source] = nil

    lib.notify(source, {
        description = 'Sesi emote berhasil di reset!',
        type = 'success'
    })
end)

lib.addCommand('playemote', {
    help = 'Mulai emote',
    params = {
        {
            name = 'name',
            type = 'string',
            help = 'Nama Emote'
        }
    }
}, function (source, args)
    if not emoteSession[source] then
        return lib.notify(source, {
            description = 'Hanya pemain yang membuat sesi emote yang bisa memulai emote!',
            type = 'error'
        })
    end

    lib.triggerClientEvent('rhd_syncAnimation:client:syncEmote', emoteSession[source], args.name)
end)

lib.addCommand('gabungsesiemote', {
    help = 'Gabung ke sesion emote orang',
    params = {
        {
            name = 'id',
            type = 'playerId',
            help = 'Id Pemilik sesion'
        }
    }
}, function (source, args)

    if emoteSession[source] then
        return lib.notify(source, {
            description = 'Kamu yang memiliki sesi ini!',
            type = 'error'
        })    
    end

    if alreadyInSession[source] then
        removeFromSession(source, alreadyInSession[source])
    end

    if not emoteSession[args.id] then
        return lib.notify(source, {
            description = 'Tidak ada sesion emote yang tersedia di ID: ' .. args.id,
            type = 'error'
        })
    end

    alreadyInSession[source] = args.id
    emoteSession[args.id][#emoteSession[args.id]+1] = source

    lib.notify(source, {
        description = 'Berhasil bergabung di sesi ' .. args.id,
        type = 'success'
    })
end)