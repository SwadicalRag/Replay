hook.Add("CalcView","ReplaySmoothView",function(ply,_,__,fov,___,____)
    if(Replay:mStatus()) then
        return {

        }
    end
end)
