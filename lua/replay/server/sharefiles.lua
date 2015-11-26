Replay:logDebug("Flagging files to be sent to the client...")

local function walkFolder(path)
    local files,folders = file.Find("lua/"..path.."*","GAME")

    for _,fileName in ipairs(files) do
        Replay:logDebug(("AddCSLuaFile(%q)"):format(path..fileName))
        AddCSLuaFile(path..fileName)
    end

    for _,folderName in ipairs(folders) do
        walkFolder(path..folderName.."/")
    end
end

walkFolder("replay/shared/")
walkFolder("replay/client/")

Replay:logDebug("Flagging complete.")
