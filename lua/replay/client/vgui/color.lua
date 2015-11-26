local colorData = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 1,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
}

hook.Add("RenderScreenspaceEffects","Replay_GreyEffect",function()
    if(Replay:mStatus()) then
        colorData["pp_colour_colour"] = math.max(0,colorData["pp_colour_colour"] - FrameTime())
    elseif(colorData["pp_colour_colour"] ~= 1) then
        colorData["pp_colour_colour"] = math.min(1,colorData["pp_colour_colour"] + FrameTime())
    end
end)
