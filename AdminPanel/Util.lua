local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

local Util = {}

function Util.findPlayer(name)
    if not name then
        return nil
    end
    local lower = string.lower(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == lower or string.sub(string.lower(player.DisplayName), 1, #lower) == lower then
            return player
        end
    end
    return nil
end

function Util.findPlayers(names)
    local results = {}
    for _, token in ipairs(names) do
        local player = Util.findPlayer(token)
        if player then
            table.insert(results, player)
        end
    end
    return results
end

function Util.sendSystemMessage(message)
    if TextChatService and TextChatService.TextChannels and TextChatService.TextChannels.RBXGeneral then
        TextChatService.TextChannels.RBXGeneral:SendAsync("[Admin] " .. message)
    end
end

function Util.hint(text, duration)
    local hint = Instance.new("Hint")
    hint.Text = text
    hint.Parent = workspace
    task.delay(duration or 5, function()
        hint:Destroy()
    end)
end

function Util.flash(player, color)
    local character = player.Character
    if not (character and character.PrimaryPart) then
        return
    end
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = color
    highlight.OutlineColor = color
    task.delay(3, function()
        highlight:Destroy()
    end)
end

function Util.getHumanoid(player)
    local character = player.Character
    if not character then
        return nil
    end
    return character:FindFirstChildOfClass("Humanoid")
end

function Util.applyPresetMotion(player, property, value)
    local humanoid = Util.getHumanoid(player)
    if humanoid then
        humanoid[property] = value
    end
end

function Util.addBillboard(part, text, color)
    if not part then
        return
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 160, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = color or Color3.fromRGB(0, 170, 255)
    label.TextScaled = true
    label.Parent = billboard

    task.delay(8, function()
        billboard:Destroy()
    end)
end

function Util.ensureTag(instance, tag)
    if not CollectionService:HasTag(instance, tag) then
        CollectionService:AddTag(instance, tag)
    end
end

function Util.withCharacter(player, callback)
    if player.Character then
        callback(player.Character)
    end
    player.CharacterAdded:Connect(function(character)
        callback(character)
    end)
end

function Util.teleportToCFrame(player, cframe)
    if player.Character and player.Character.PrimaryPart then
        player.Character:SetPrimaryPartCFrame(cframe)
    end
end

function Util.storeCFrame(player)
    if player.Character and player.Character.PrimaryPart then
        return player.Character.PrimaryPart.CFrame
    end
    return nil
end

function Util.playSound(trackName, soundId)
    local soundService = game:GetService("SoundService")
    local existing = soundService:FindFirstChild(trackName)
    if existing then
        existing:Destroy()
    end
    local sound = Instance.new("Sound")
    sound.Name = trackName
    sound.SoundId = soundId
    sound.Looped = true
    sound.Volume = 0.5
    sound.Parent = soundService
    sound:Play()
end

function Util.stopSound(trackName)
    local soundService = game:GetService("SoundService")
    local existing = soundService:FindFirstChild(trackName)
    if existing then
        existing:Stop()
        existing:Destroy()
    end
end

function Util.teletype(player, text)
    local character = player.Character
    if not (character and character.PrimaryPart) then
        return
    end
    local label = Instance.new("BillboardGui")
    label.Size = UDim2.new(0, 200, 0, 60)
    label.AlwaysOnTop = true
    label.Parent = character.PrimaryPart

    local textLabel = Instance.new("TextLabel")
    textLabel.BackgroundTransparency = 0.2
    textLabel.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
    textLabel.BorderSizePixel = 0
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.TextWrapped = true
    textLabel.Text = text
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    textLabel.Parent = label

    task.delay(6, function()
        label:Destroy()
    end)
end

function Util.colorPreset(name, ambient, outdoor)
    Lighting.Ambient = ambient
    Lighting.OutdoorAmbient = outdoor or ambient
    Util.sendSystemMessage("Lighting preset '" .. name .. "' applied.")
end

function Util.parseDuration(text)
    local value = tonumber(text)
    if not value then
        return nil
    end
    return math.max(0, value)
end

function Util.describePlayers(list)
    local names = {}
    for _, player in ipairs(list) do
        table.insert(names, player.Name)
    end
    return table.concat(names, ", ")
end

return Util
