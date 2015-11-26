util.AddNetworkString("replay_setManipulating")
util.AddNetworkString("replay_setVelocity")

net.Receive("replay_setManipulating",function(len,ply)
    local status = net.ReadBool()
    if ply.recorderObject then
        if status then
            ply:Lock()
            ply.recorderObject:startManipulating()-- and stop recording
        else
            local targetFrame,frameID = ply.recorderObject:getFrameFromCommandNumber(net.ReadInt(24))
            ply:UnLock()
            if targetFrame then
                ply.recorderObject:jumpToAbsoluteFrame(frameID)
                ply.recorderObject:stopManipulating()

                local frame = ply.recorderObject:getCurrentFrame()

                ply:SetPos(frame.position)
                ply:SetEyeAngles(frame.eyeAngles)
                ply:SetVelocity(frame.velocity)
                --ply:SetHealth(frame.health)
                --ply:SetArmor(frame.armor)
            else
                Replay:logError("Unreasonable replay request from "..ply:Nick())-- should never happen
            end
        end
    end
end)

net.Receive("replay_setVelocity",function(len,ply)
    ply.replay_velocity = net.ReadInt(8)
end)
