util.AddNetworkString("replay_setManipulating")

net.Receive("replay_setManipulating",function(len,ply)
    local status = net.ReadBool()
    if ply.recorderObject then
        if status then
            ply.recorderObject:startManipulating()-- and stop recording
        else
            local targetFrame,frameID = ply.recorderObject:getFrameFromCommandNumber(net.ReadInt(24))
            if targetFrame then
                ply.recorderObject:jumpToAbsoluteFrame(frameID)
                ply.recorderObject:stopManipulating()
            else
                Replay:logError("Unreasonable replay request from "..ply:Nick())-- should never happen
            end
        end
    end
end)
