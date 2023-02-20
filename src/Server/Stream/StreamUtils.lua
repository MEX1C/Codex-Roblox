local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StreamUtils = {}

function StreamUtils.ResolvePlayerSchemaIndex(index : number | Player)
    if typeof(index) == "Instance" and index:IsA("Player") then
        return tostring(index.UserId)
    elseif type(index) == "number" or type(index) == "string" and tonumber(index) then
        return tostring(index)
    else
        error("Invalid index type. Expected Player or userid, got " .. typeof(index))
    end
end

function StreamUtils.MakeRemote(remoteType : "Function" | "Event", name : string)
	local RemoteFolder = ReplicatedStorage:FindFirstChild("_STREAM_REMOTES")
	if not RemoteFolder then
		RemoteFolder = Instance.new("Folder")
		RemoteFolder.Name = "_STREAM_REMOTES"
		RemoteFolder.Parent = ReplicatedStorage
	end

	local NewRemote = Instance.new("Remote"..remoteType)
	NewRemote.Name = name
	NewRemote.Parent = RemoteFolder

	return NewRemote
end

function StreamUtils.CopyTable(target)
	local new = {}
	for key, value in pairs(target) do
		new[key] = value
	end
	return new
end

function StreamUtils:DeepCopyTable(target, _context)
    _context = _context or  {}
    if _context[target] then
        return _context[target]
    end

    if type(target) == "table" then
        local new = {}
        _context[target] = new
        for index, value in pairs(target) do
            new[self:DeepCopyTable(index, _context)] = self:DeepCopyTable(value, _context)
        end
        return setmetatable(new, self:DeepCopyTable(getmetatable(target), _context))
    else
        return target
    end
end

return StreamUtils