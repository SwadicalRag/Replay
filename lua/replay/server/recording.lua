hook.Add("PlayerTick","ReplayRecorder",function(ply,_)
    if not ply.recorderObject then
        ply.recorderObject = Replay:newRecorder()
        ply.recorderObject:attach(ply)
    end
    ply.recorderObject:captureFrame()
end)
