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
end

function Replay:getSpeed()
    return self.replaySpeed or 1
end

function Replay:setSpeed(speed)
    self.replayDirection = math.abs(speed)
    self:setDirection(speed)
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
        local elapsed = SysTime() - self.recorderObject.startedManipulatingAt
        return self.recorderObject:interpolateFrame(self.recorderObject:getCurrentFrame(),self:getDirection() * elapsed)
    else
        return false
    end
end

timer.Create("Replay_Nautilus_Update",0,0,function()
    if not Replay.recorderObject then return end
    if(Replay:mStatus()) then
        if(Replay:getDirection() > 0) then
            Replay.recorderObject:jumpForward()
        else
            Replay.recorderObject:jumpBackward()
        end
    end
end)
