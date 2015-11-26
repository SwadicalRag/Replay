--Nautilus: traverse time!

--convenience function
function Replay:mStatus()
    return self.recorderObject:getManipulating()
end

function Replay:getDirection()
    return self.replayDirection or 1
end

function Replay:setDirection(sign)
    self.replayDirection = sign/math.abs(sign)
    self:announceReplayVelocity(self:getVelocity())
end

function Replay:getSpeed()
    return self.replaySpeed or 1
end

function Replay:setSpeed(speed)
    self.replaySpeed = math.abs(speed)
    self:announceReplayVelocity(self:getVelocity())
end

function Replay:setVelocity(velocity)
    self:setSpeed(velocity)
    self:setDirection(velocity)
end

function Replay:getVelocity()
    return self:getDirection() * self:getSpeed()
end

function Replay:startManipulating()
    self.recorderObject:startManipulating()
    self:announceManipulationStart()
end

function Replay:stopManipulating()
    self.recorderObject:stopManipulating()
    self:announceManipulationEnd()
end

function Replay:currentFrame()
    if(self:mStatus()) then
        local elapsed = SysTime() - self.lastFrameUpdate
        return self.recorderObject:interpolateFrame(self:getDirection() * self:getSpeed() * elapsed)
        --return self.recorderObject:getCurrentFrame()
    else
        return false
    end
end

hook.Add("PlayerTick","Replay_Nautilus_Update",function()
    if(Replay:mStatus()) then
        Replay.recorderObject:jump(Replay:getVelocity())
        if(Replay.recorderObject.activeFrame%0) then
            Replay.lastFrameUpdate = SysTime()
        end
    end
end)
