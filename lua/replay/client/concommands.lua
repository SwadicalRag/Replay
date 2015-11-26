concommand.Add("replay_forward",function()
    Replay:setDirection(1)
end)

concommand.Add("replay_backward",function()
    Replay:setDirection(-1)
end)

concommand.Add("replay_speed_half",function()
    Replay:setSpeed(0.5)
end)

concommand.Add("replay_speed_normal",function()
    Replay:setSpeed(1)
end)

concommand.Add("replay_speed_double",function()
    Replay:setSpeed(2)
end)

concommand.Add("+replay_manipulate",function()
    Replay:startManipulating()
end)

concommand.Add("-replay_manipulate",function()
    Replay:stopManipulating()
end)
