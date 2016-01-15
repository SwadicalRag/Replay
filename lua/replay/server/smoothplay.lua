hook.Add("PlayerTick","Replay_Nautilus_Update",function(ply,_)
    if(ply.recorderObject and ply.recorderObject:getManipulating()) then
        ply.recorderObject:jump(ply.replay_velocity)
        if(ply.recorderObject.activeFrame % 0) then
            ply.replay_lastFrameUpdate = SysTime()
        end

        local frame = ply.recorderObject:getCurrentFrame()

        ply:SetPos(frame.position)
        ply:SetEyeAngles(frame.eyeAngles)
        --ply:SetVelocity(frame.velocity)
    end
end)
