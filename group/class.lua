---@class awokawok:OxClass
local awokawok = lib.class('awokawok')

function awokawok:constructor(source)
    self.id = source
    self.emote = nil
    self.member = { [source] = 'pemilik' }
    self.lagidance = false
    return self
end

function awokawok:getId()
    return self.id
end

function awokawok:mulai(emote)
    local list = {}
    for id in pairs(self.member) do
        list[#list+1] = id
    end
    self.emote = emote
    self.lagidance = true
    lib.TriggerClientEvent('rhd_dancegroup:client:mulai', list, self.emote)
end

function awokawok:berhenti()
    local list = {}
    for id in pairs(self.member) do
        list[#list+1] = id
    end
    self.emote = nil
    self.lagidance = false
    lib.TriggerClientEvent('rhd_dancegroup:client:stop', list)
end

function awokawok:hapus(source, cb)
    local list = {}
    for id in pairs(self.member) do
        cb(id)
        list[#list+1] = id
        pcall(lib.notify, id, {description = 'Sesi dance group telah dibubarkan'})
    end
    lib.TriggerClientEvent('rhd_dancegroup:client:stop', list)
end

function awokawok:gabung(source)
    self.member[source] = 'anggota'

    if self.lagidance then
        self:mulai(self.emote)
    end
end

function awokawok:keluar(source, cb)
    if self.member[source] == 'pemilik' then
        self:hapus(source, cb)
        return
    end

    if cb then cb(source) end
    self.member[source] = nil
    lib.TriggerClientEvent('rhd_dancegroup:client:stop', source)
end

return awokawok