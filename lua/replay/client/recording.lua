hook.Add("InitPostEntity","ReplayRecorderInitialisation",function()
    LocalPlayer().recorderObject = Replay:newRecorder()
    LocalPlayer().recorderObject:attach(LocalPlayer())
    Replay.recorderObject = LocalPlayer().recorderObject
    Replay:logDebug("Recorder object initialised clientside.")
end)

hook.Add("PlayerTick","ReplayRecorder",function(ply,_)
    if ply ~= LocalPlayer() then return end
    ply.recorderObject:captureFrame()
end)
