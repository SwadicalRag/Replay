Replay = {}

Replay.DEBUG = true
Replay.VERSION = "0.1.0"
Replay.startTime = SysTime()

function Replay:log(msg)
    MsgC(Color(0,255,255),("[Replay] [T+%.02fs] [OUT] "):format(SysTime() - self.startTime),Color(255,255,255),msg,"\n")
end

function Replay:logDebug(msg)
    if not self.DEBUG then return end
    MsgC(Color(255,255,0),("[Replay] [T+%.02fs] [DBG] "):format(SysTime() - self.startTime),Color(255,255,255),msg,"\n")
end

function Replay:logError(msg)
    MsgC(Color(255,0,0),("[Replay] [T+%.02fs] [ERR] "):format(SysTime() - self.startTime),Color(255,255,255),msg,"\n")
end

Replay:log("Initialising...")

include("replay/shared/recorder.lua")

include("replay/"..((SERVER and "server") or "client").."/init.lua")

Replay:log("Replay "..Replay.VERSION.." has successfully initialised.")
