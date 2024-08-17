RegisterNetEvent('client:syncEmote', function()
    local pState = LocalPlayer.state

    if not pState.prepare_emote then
        return
    end
    
    ExecuteCommand('e '..pState.prepare_emote)
  
    pState:set('prepare_emote', nil, true)
end)