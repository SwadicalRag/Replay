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
