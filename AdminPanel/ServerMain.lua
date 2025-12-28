local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local Config = require(script.Parent.Config)
local CommandRegistry = require(script.Parent.Commands)
local Util = require(script.Parent.Util)

local registry = CommandRegistry.new(Config)
registry:registerDefaults()

local AdminEvent = ReplicatedStorage:FindFirstChild("AdminPanelEvent") or Instance.new("RemoteEvent")
AdminEvent.Name = "AdminPanelEvent"
AdminEvent.Parent = ReplicatedStorage

local AdminListFunction = ReplicatedStorage:FindFirstChild("AdminPanelList") or Instance.new("RemoteFunction")
AdminListFunction.Name = "AdminPanelList"
AdminListFunction.Parent = ReplicatedStorage

local function hasPermission(player)
    return Config.AdminUserIds[player.UserId] or (Config.AdminUserIds["Owner"] and player.UserId == game.CreatorId)
end

local function applyChatTag(player)
    local tag = player:GetAttribute("ChatTag")
    if Config.Logging.AnnounceJoins and tag and TextChatService.TextChannels and TextChatService.TextChannels.RBXGeneral then
        TextChatService.TextChannels.RBXGeneral:SendAsync("[" .. tag .. "] " .. player.DisplayName .. " has joined.")
    end
end

Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        registry:handle(player, message)
    end)
    applyChatTag(player)
end)

AdminEvent.OnServerEvent:Connect(function(player, payload)
    if payload.type == "run" and type(payload.command) == "string" then
        registry:handle(player, Config.CommandPrefix .. payload.command)
    end
end)

AdminListFunction.OnServerInvoke = function(player)
    if not hasPermission(player) then
        return {}
    end
    return { prefix = Config.CommandPrefix, commands = registry:list() }
end

-- Clean ban list on heartbeat
while true do
    for userId, expiry in pairs(registry.banList) do
        if expiry ~= true and tick() > expiry then
            registry.banList[userId] = nil
        end
    end
    task.wait(30)
end
