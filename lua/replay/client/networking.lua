function Replay:announceManipulationStart()
    net.Start("replay_setManipulating")
        net.WriteBool(true)
    net.SendToServer()
end

function Replay:announceManipulationEnd()
    net.Start("replay_setManipulating")
        net.WriteBool(false)
        net.WriteInt(self.recorderObject:getCurrentFrame().cmdnum,24)
    net.SendToServer()
end

function Replay:announceReplayVelocity(vel)
    net.Start("replay_setVelocity")
        net.WriteInt(vel,8)
    net.SendToServer()
end
