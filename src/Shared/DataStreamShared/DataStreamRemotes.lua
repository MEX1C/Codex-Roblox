--[[
    DataStreamRemotes.lua
    Stratiz
    Created/Documented on 03/27/2024 @ 12:29:20
    
    Description:
        Handles remote events
    
--]]


--= Root =--
local DataStreamRemotes = { }

--= Roblox Services =--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--= Dependencies =--

--= Types =--

--= Variables =--

local IsServer = RunService:IsServer()

--= Constants =--

local REMOTE_FOLDER_NAME = "_TABLE_REPLICATION_REMOTES"

--= Object References =--

local RemoteFolder = IsServer == false and ReplicatedStorage:WaitForChild(REMOTE_FOLDER_NAME) or nil
local RemoteCache = {
    Function = {},
    Event = {}
}

--= Public Variables =--

--= Internal Functions =--

--= API Functions =--

function DataStreamRemotes:Get(remoteType : "Function" | "Event", name : string)
    local internalName = remoteType .. name
    if RemoteCache[remoteType][name] then
        return RemoteCache[remoteType][name]
    end

    if IsServer then
        if not RemoteFolder then
            RemoteFolder = Instance.new("Folder")
            RemoteFolder.Name = REMOTE_FOLDER_NAME
            RemoteFolder.Parent = ReplicatedStorage
        end

        local NewRemote = Instance.new("Remote"..remoteType)
        NewRemote.Name = internalName
        NewRemote.Parent = RemoteFolder

        RemoteCache[remoteType][name] = NewRemote

        return NewRemote
    else
        local foundRemote = RemoteFolder:WaitForChild(internalName)

        RemoteCache[remoteType][name] = foundRemote

        return foundRemote
    end
end

--= Return Module =--
return DataStreamRemotes
