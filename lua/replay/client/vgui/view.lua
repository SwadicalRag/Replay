hook.Add("CalcView","ReplaySmoothView",function(ply,pos,__,fov,___,____)
    if(Replay:mStatus()) then
        local frame = Replay:currentFrame()
        return {
            origin = frame.eyePos,
            angles = frame.eyeAngles,
            fov = fov
        }
    end
end)

hook.Add("CalcViewModelView","ReplaySmoothView",function()
    if(Replay:mStatus()) then
        local frame = Replay:currentFrame()
        return frame.eyePos,frame.eyeAngles
    end
end)
