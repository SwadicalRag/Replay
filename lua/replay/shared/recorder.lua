Replay:logDebug("Loading shared recorder library...")

-- HACK: this library assumes recorder:captureFrame is called each TICK (every engine.TickInterval() seconds)

function Replay:newRecorder()
    local recorder = {}
    recorder.data = {}
    recorder.frameInterval = engine.TickInterval()
    recorder.maxTime = 30--seconds
    recorder.maxData = 30/recorder.frameInterval
    recorder.activeFrame = 1

    function recorder:attach(ply)
        Replay:logDebug("A recorder object was attached to "..tostring(ply)..".")
        self.ply = ply
    end

    --Internal: do not call.
    function recorder:checkAttached()
        assert(IsValid(self.ply),"This recorder class is unattached!")
    end

    --Internal: do not call.
    function recorder:getManipulating()
        return self.isBeingManipulated or false
    end

    --Internal: do not call.
    function recorder:setManipulating(state)
        self.isBeingManipulated = state or false
    end

    function recorder:captureFrame()
        self:checkAttached()
        if self:getManipulating() then return end
        self.data[#self.data+1] = {
            position = self.ply:GetPos(),
            velocity = self.ply:GetVelocity(),
            eyeAngles = self.ply:EyeAngles(),
            health = self.ply:Health(),
            armor = self.ply:Armor(),
            time = CurTime(),
            cmdnum = self.ply:GetCurrentCommand():CommandNumber()
        }

        if(#self.data > self.maxData) then
            table.remove(self.data,1)
        end
        recorder.activeFrame = #self.data
    end

    function recorder:startManipulating()
        self.startedManipulatingAt = CurTime()
        self:setManipulating(true)
        Replay:logDebug("A recorder object is now being manipulated.")
    end

    function recorder:stopManipulating()
        for i=self.activeFrame+1,#self.data do
            self.data[i] = nil
        end
        self:setManipulating(false)
        Replay:logDebug("A recorder object no longer being manipulated.")
    end

    function recorder:jumpToAbsoluteFrame(framesBackward)
        self.activeFrame = math.min(math.max(#self.data-framesBackward,1),#self.data)
        return self.data[self.activeFrame]
    end

    function recorder:jumpBackward(n)
        self.activeFrame = math.min(math.max(self.activeFrame - (n or 1),1),#self.data)
        return self.data[self.activeFrame]
    end

    function recorder:jumpForward(n)
        self.activeFrame = math.min(math.max(self.activeFrame + (n or 1),1),#self.data)
        return self.data[self.activeFrame]
    end

    function recorder:getCurrentFrame()
        return self.data[self.activeFrame]
    end

    function recorder:getFrameSigned(n)
        return self.data[math.min(math.max(self.activeFrame + sign/math.abs(n),1),#self.data)]
    end

    function recorder:interpolateFrame(frame,sec)
        local frac = math.abs(sec/self.frameInterval)
        local frameNext = self:getFrameSigned(sec)
        return {
            position = LerpVector(frac,frame.position,frameNext.position),
            velocity = LerpVector(frac,frame.velocity,frameNext.velocity),
            eyeAngles = LerpAngle(frac,frame.eyeAngles,frameNext.eyeAngles),
            health = Lerp(frac,frame.health,frameNext.health),
            armor = Lerp(frac,frame.armor,frameNext.armor),
            time = Lerp(frac,frame.time,frameNext.time),
            cmdnum = Lerp(frac,frame.cmdnum,frameNext.cmdnum)
        }
    end

    return recorder
end
