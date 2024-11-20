local emoteSession = {}
local alreadyInSession = {}

local function removeFromSession(source)
    for _, v in pairs(emoteSession) do
        if v and type(v) == "table" and table.type(v) == 'array' then
            for i=1, #v do
                local src = v[i]
                if src == source then
                    emoteSession[_][i] = nil
                    break
                end
            end
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
    alreadyInSession[source] = true
    emoteSession[source] = {
        source
    }
    lib.notify(source, {
        description = 'Berhasil membuat sesi emote',
        type = 'success'
    })
end)

lib.addCommand('resetsesiemote', {
    help = 'Reset session emote',
}, function (source)
    if not emoteSession[source] then
        return lib.notify(source, {
            description = 'Kamu belum pernah membuat sesi emote!',
            type = 'error'
        })
    end

    for i=1, #emoteSession[source] do
        local memberSource = emoteSession[source][i]
        alreadyInSession[memberSource] = false
    end

    alreadyInSession[source] = false
    emoteSession[source] = nil

    lib.notify(source, {
        description = 'Sesi emote berhasil di hapus!',
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

    if alreadyInSession[source] then
        removeFromSession(source)
    end

    if not emoteSession[args.id] then
        return lib.notify(source, {
            description = 'Tidak ada sesion emote yang tersedia di ID: ' .. args.id,
            type = 'error'
        })
    end

    alreadyInSession[source] = true
    emoteSession[args.id][#emoteSession[args.id]+1] = source

    lib.notify(source, {
        description = 'Berhasil bergabung di sesi ' .. args.id,
        type = 'success'
    })
end)