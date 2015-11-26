Replay:logDebug("Loading shared recorder library...")

-- HACK: this library assumes recorder:captureFrame is called each TICK (every engine.TickInterval() seconds)

local function lerpGeneric(frac,from,to)
    return from + (to-from) * frac
end

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

        if CLIENT then self.data[#self.data].eyePos = EyePos() end

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

    function recorder:jumpToAbsoluteFrame(frameID)
        self.activeFrame = math.min(math.max(frameID,1),#self.data)
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
        return self.data[math.min(math.max(self.activeFrame + n/math.abs(n),1),#self.data)]
    end

    function recorder:getFrameFromCommandNumber(cmdnum)
        local minDiff = math.huge
        local closestFrame = false
        local closestFrameID = false

        for frameID,frame in ipairs(self.data) do
            local diff = math.abs(cmdnum-frame.cmdnum)
            minDiff = math.min(minDiff,diff)
            if diff == minDiff then
                closestFrame = frame
                closestFrameID = frameID
            end
        end

        return closestFrame,closestFrameID
    end

    function recorder:interpolateFrame(frame,sec)
        local frac = math.abs(sec/self.frameInterval)
        local frameNext = self:getFrameSigned(sec)
        local data = {
            position = lerpGeneric(frac,frame.position,frameNext.position),
            velocity = lerpGeneric(frac,frame.velocity,frameNext.velocity),
            eyeAngles = lerpGeneric(frac,frame.eyeAngles,frameNext.eyeAngles),
            health = lerpGeneric(frac,frame.health,frameNext.health),
            armor = lerpGeneric(frac,frame.armor,frameNext.armor),
            time = lerpGeneric(frac,frame.time,frameNext.time),
            cmdnum = lerpGeneric(frac,frame.cmdnum,frameNext.cmdnum)
        }

        if CLIENT then
            data.eyePos = lerpGeneric(frac,frame.eyePos,frameNext.eyePos)
        end

        return data
    end

    return recorder
end
