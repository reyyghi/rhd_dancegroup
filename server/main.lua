local group = {}
local sesiiiiiiii = {}

local anjay = require 'group.class'

local function getSesi(source)
    return group[source] or sesiiiiiiii[source] and group[sesiiiiiiii[source]]
end

lib.addCommand('bsd', {
    help = 'Buat sesi dance emote'
}, function (source)
    local sesidance = getSesi(source)
    if sesidance then
        return lib.notify(source, {
            description = 'Kamu sudah berada di dalam sesi dance: ' .. sesidance:getId(),
            type = 'error'
        })
    end

    group[source] = anjay:new(source)
    lib.notify(source, {description = 'Sesi emote berhasil dibuat! SESI ID: ' .. source})
end)

lib.addCommand('csd', {
    help = 'Cek sesi id dance emote'
}, function (source)
    local sesidance = getSesi(source)

    if not sesidance then
        return lib.notify(source, {
            description = 'Kamu belum gabung ke sesi dance manapun!',
            type = 'error'
        })
    end

    lib.notify(source, {description = 'Sesi dance emote kamu sekarang adalah ' .. sesidance:getId()})
end)

lib.addCommand('ksd', {
    help = 'Keluar sesi dance emote'
}, function (source)
    local sesidance = getSesi(source)

    if not sesidance then
        return lib.notify(source, {
            description = 'Kamu belum gabung ke sesi dance manapun!',
            type = 'error'
        })
    end

    sesidance:keluar(source, function (id)
        group[id] = nil
        sesiiiiiiii[id] = nil
    end)

    lib.notify(source, {description = 'Kamu telah keluar dari sesi dance.', type = 'success'})
end)

lib.addCommand('gsd', {
    help = 'Gabung ke sesi dance emote',
    params = {
        {
            name = 'sesi_id',
            type = 'number',
            help = 'Sesi Id'
        }
    }
}, function (source, args)
    local sesi = args.sesi_id
    local sesidance = getSesi(source)

    if sesidance then
        return lib.notify(source, {
            description = 'Kamu harus keluar terlebih dahulu dari sesi dance emote saat ini!',
            type = 'error'
        })
    end

    if not group[sesi] then
        return lib.notify(source, {
            description = 'Tidak ada sesi dance emote yang tersedia dengan ID: ' .. sesi,
            type = 'error'
        })
    end

    sesiiiiiiii[source] = sesi
    group[sesi]:gabung(source)

    lib.notify(source, {
        description = 'Kamu telah bergabung ke dalam sesi dance emote ('..sesi..')',
        type = 'success'
    })
end)

lib.addCommand('msd', {
    help = 'Mulai sesi dance emote',
    params = {
        {
            name = 'emote',
            type = 'string',
            help = 'Nama emote nya'
        }
    }
}, function (source, args)
    if not group[source] then
        return lib.notify(source, {
            description = 'Hanya pemimpin group yang dapat memulai/memberhentikan sesi dance',
            type = 'error'
        })
    end
    group[source]:mulai(args.emote)
end)

lib.addCommand('ssd', {
    help = 'Stop sesi dance emote'
}, function (source)
    if not group[source] then
        return lib.notify(source, {
            description = 'Hanya pemimpin group yang dapat memulai/memberhentikan sesi dance',
            type = 'error'
        })
    end

    group[source]:berhenti()
end)

AddEventHandler('playerDropped', function ()
    local source = source
    local sesiemote = getSesi(source)
    sesiemote:keluar(source, function (me)
        group[me] = nil
        sesiiiiiiii[me] = nil
    end)
    lib.print.info('Sesi dance emote ' .. sesiemote:getId() .. ' telah di bubarkan karena pemain telah keluar dai server.')
end)