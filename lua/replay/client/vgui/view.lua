hook.Add("CalcView","ReplaySmoothView",function(ply,_,__,fov,___,____)
    if(Replay:mStatus()) then
        local frame = Replay:currentFrame()
        return {
            origin = frame.eyePos,
            angles = frame.eyeAngles,
            fov = fov
        }
    end
end)
