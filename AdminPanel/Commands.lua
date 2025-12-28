local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local Util = require(script.Parent.Util)
local AI = require(script.Parent.AI)

local CommandRegistry = {}
CommandRegistry.__index = CommandRegistry

function CommandRegistry.new(config)
    local self = setmetatable({}, CommandRegistry)
    self.config = config
    self.commands = {}
    self.total = 0
    self.banList = {}
    self.muted = {}
    self.history = {}
    self.waypoints = {}
    self.cooldowns = {}
    return self
end

function CommandRegistry:register(command)
    self.commands[command.name] = command
    self.total += 1
end

function CommandRegistry:get(name)
    local lower = string.lower(name)
    for _, command in pairs(self.commands) do
        if string.lower(command.name) == lower then
            return command
        end
        if command.aliases then
            for _, alias in ipairs(command.aliases) do
                if string.lower(alias) == lower then
                    return command
                end
            end
        end
    end
    return nil
end

function CommandRegistry:list()
    local list = {}
    for name, command in pairs(self.commands) do
        table.insert(list, {
            name = name,
            description = command.description,
            category = command.category,
        })
    end
    table.sort(list, function(a, b)
        return a.name < b.name
    end)
    return list
end

function CommandRegistry:pushHistory(player, name, args)
    local entry = string.format("%s :: %s %s", player.Name, name, formatArgs(args or {}))
    table.insert(self.history, 1, entry)
    if #self.history > self.config.Logging.HistorySize then
        table.remove(self.history)
    end
    if self.config.Logging.EchoCommandsToChat then
        Util.sendSystemMessage(entry)
    end
end

local function requireAdmin(player, registry)
    if registry.config.AdminUserIds[player.UserId] then
        return true
    end
    if registry.config.AdminUserIds["Owner"] and player.UserId == game.CreatorId then
        return true
    end
    return false
end

local function formatArgs(args)
    return table.concat(args, " ")
end

local function commandContext(player, message, registry)
    return {
        player = player,
        message = message,
        registry = registry,
        respond = function(text)
            Util.sendSystemMessage(text)
        end,
    }
end

function CommandRegistry:registerDefaults()
    local function reg(def)
        self:register(def)
    end

    reg({
        name = "help",
        description = "Display all available commands.",
        category = "Utility",
        run = function(ctx)
            local names = {}
            for _, cmd in ipairs(ctx.registry:list()) do
                table.insert(names, cmd.name)
            end
            ctx.respond("Commands (" .. #names .. "): " .. table.concat(names, ", "))
        end,
    })

    reg({
        name = "commands",
        description = "Send the command list to the caller.",
        category = "Utility",
        run = function(ctx)
            local names = {}
            for _, cmd in ipairs(ctx.registry:list()) do
                table.insert(names, cmd.name .. " - " .. cmd.description)
            end
            ctx.respond(table.concat(names, " | "))
        end,
    })

    reg({
        name = "history",
        description = "Show the most recent admin actions.",
        category = "Utility",
        run = function(ctx)
            if #ctx.registry.history == 0 then
                ctx.respond("No admin actions recorded yet.")
                return
            end
            ctx.respond(table.concat(ctx.registry.history, " | "))
        end,
    })

    reg({
        name = "kick",
        description = "Kick a player.",
        category = "Moderation",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            if target then
                target:Kick("Kicked by " .. ctx.player.Name .. (args[2] and (": " .. formatArgs(args, 2)) or ""))
                ctx.respond("Kicked " .. target.Name)
            end
        end,
    })

    reg({
        name = "ban",
        description = "Ban a player permanently.",
        category = "Moderation",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            if target then
                ctx.registry.banList[target.UserId] = true
                target:Kick("You have been banned by " .. ctx.player.Name)
                ctx.respond("Banned " .. target.Name)
            end
        end,
    })

    reg({
        name = "unban",
        description = "Remove a player from the ban list.",
        category = "Moderation",
        run = function(ctx, args)
            local userId = tonumber(args[1])
            if userId then
                ctx.registry.banList[userId] = nil
                ctx.respond("UserId " .. userId .. " unbanned.")
            end
        end,
    })

    reg({
        name = "tempban",
        description = "Temporarily ban a player (minutes).",
        category = "Moderation",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            local minutes = tonumber(args[2]) or ctx.registry.config.Moderation.DefaultBanLengthMinutes
            minutes = math.min(minutes, ctx.registry.config.Moderation.TempBanMaxMinutes)
            if target then
                ctx.registry.banList[target.UserId] = tick() + (minutes * 60)
                target:Kick("Temporarily banned for " .. minutes .. " minutes.")
                ctx.respond("Temp-banned " .. target.Name .. " for " .. minutes .. " minutes")
            end
        end,
    })

    reg({
        name = "mute",
        description = "Mute a player from chat.",
        category = "Moderation",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            if target then
                ctx.registry.muted[target.UserId] = true
                ctx.respond(target.Name .. " has been muted.")
            end
        end,
    })

    reg({
        name = "unmute",
        description = "Unmute a player.",
        category = "Moderation",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            if target then
                ctx.registry.muted[target.UserId] = nil
                ctx.respond(target.Name .. " has been unmuted.")
            end
        end,
    })

    reg({
        name = "freeze",
        description = "Freeze a player in place.",
        category = "Action",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            local humanoid = target and Util.getHumanoid(target)
            if humanoid then
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
                ctx.respond(target.Name .. " has been frozen.")
            end
        end,
    })

    reg({
        name = "unfreeze",
        description = "Return a player to default movement.",
        category = "Action",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            local humanoid = target and Util.getHumanoid(target)
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
                ctx.respond(target.Name .. " unfrozen.")
            end
        end,
    })

    reg({
        name = "heal",
        description = "Heal a player to full health.",
        category = "Action",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            local humanoid = target and Util.getHumanoid(target)
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
                ctx.respond(target.Name .. " healed.")
            end
        end,
    })

    reg({
        name = "damage",
        description = "Deal damage to a player.",
        category = "Action",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            local amount = tonumber(args[2]) or 10
            local humanoid = target and Util.getHumanoid(target)
            if humanoid then
                humanoid:TakeDamage(amount)
                ctx.respond(target.Name .. " damaged for " .. amount)
            end
        end,
    })

    reg({
        name = "kill",
        description = "Eliminate a player immediately.",
        category = "Action",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            local humanoid = target and Util.getHumanoid(target)
            if humanoid then
                humanoid.Health = 0
                ctx.respond(target.Name .. " eliminated.")
            end
        end,
    })

    reg({
        name = "respawn",
        description = "Respawn a player.",
        category = "Action",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            if target then
                target:LoadCharacter()
                ctx.respond(target.Name .. " respawned.")
            end
        end,
    })

    reg({
        name = "shield",
        description = "Give a player a temporary shield.",
        category = "Action",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            if target and target.Character then
                local ff = Instance.new("ForceField")
                ff.Parent = target.Character
                Util.flash(target, Color3.fromRGB(0, 170, 255))
                task.delay(12, function()
                    ff:Destroy()
                end)
                ctx.respond(target.Name .. " is shielded for 12s")
            end
        end,
    })

    reg({
        name = "tp",
        description = "Teleport to a player.",
        category = "Movement",
        aliases = {"teleport"},
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            if target and target.Character and target.Character.PrimaryPart and ctx.player.Character and ctx.player.Character.PrimaryPart then
                local dest = target.Character.PrimaryPart.CFrame * CFrame.new(2, 0, 0)
                ctx.player.Character:SetPrimaryPartCFrame(dest)
                ctx.respond("Teleported to " .. target.Name)
            end
        end,
    })

    reg({
        name = "bring",
        description = "Bring another player to you.",
        category = "Movement",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            if target and target.Character and target.Character.PrimaryPart and ctx.player.Character and ctx.player.Character.PrimaryPart then
                local dest = ctx.player.Character.PrimaryPart.CFrame * CFrame.new(3, 0, 0)
                target.Character:SetPrimaryPartCFrame(dest)
                ctx.respond("Brought " .. target.Name)
            end
        end,
    })

    reg({
        name = "to",
        description = "Teleport another player to a target player.",
        category = "Movement",
        run = function(ctx, args)
            local mover = Util.findPlayer(args[1])
            local target = Util.findPlayer(args[2])
            if mover and target and mover.Character and target.Character and mover.Character.PrimaryPart and target.Character.PrimaryPart then
                local dest = target.Character.PrimaryPart.CFrame * CFrame.new(2, 0, 0)
                mover.Character:SetPrimaryPartCFrame(dest)
                ctx.respond("Moved " .. mover.Name .. " to " .. target.Name)
            end
        end,
    })

    reg({
        name = "speed",
        description = "Set player walkspeed.",
        category = "Movement",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            local value = tonumber(args[2]) or 16
            Util.applyPresetMotion(target, "WalkSpeed", value)
            ctx.respond(target.Name .. " speed set to " .. value)
        end,
    })

    reg({
        name = "jump",
        description = "Set player jumppower.",
        category = "Movement",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            local value = tonumber(args[2]) or 50
            Util.applyPresetMotion(target, "JumpPower", value)
            ctx.respond(target.Name .. " jump power set to " .. value)
        end,
    })

    reg({
        name = "gravity",
        description = "Adjust world gravity.",
        category = "World",
        run = function(ctx, args)
            local value = tonumber(args[1]) or 196.2
            workspace.Gravity = value
            ctx.respond("Gravity set to " .. value)
        end,
    })

    reg({
        name = "announce",
        description = "Broadcast an announcement to all players.",
        category = "Communications",
        run = function(ctx, args)
            Util.sendSystemMessage("ANNOUNCEMENT: " .. formatArgs(args))
        end,
    })

    reg({
        name = "setprefix",
        description = "Update the admin command prefix.",
        category = "Communications",
        run = function(ctx, args)
            local newPrefix = args[1]
            if newPrefix and #newPrefix > 0 then
                ctx.registry.config.CommandPrefix = newPrefix
                ctx.respond("Prefix changed to '" .. newPrefix .. "'")
            end
        end,
    })

    reg({
        name = "pm",
        description = "Private message a player.",
        category = "Communications",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            if target then
                Util.sendSystemMessage("[PM to " .. target.Name .. "] " .. formatArgs({table.unpack(args, 2)}))
            end
        end,
    })

    reg({
        name = "ai",
        description = "Ask the integrated AI a question.",
        category = "AI",
        run = function(ctx, args)
            local prompt = formatArgs(args)
            local response = AI.generate(ctx.registry.config.AI, prompt)
            ctx.respond("AI: " .. response)
        end,
    })

    reg({
        name = "orbit",
        description = "Orbit a player around you.",
        category = "Fun",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1])
            if target and target.Character and target.Character.PrimaryPart and ctx.player.Character and ctx.player.Character.PrimaryPart then
                local base = ctx.player.Character.PrimaryPart
                local part = target.Character.PrimaryPart
                local angle = 0
                task.spawn(function()
                    for _ = 1, 240 do
                        angle += math.pi / 8
                        local offset = CFrame.new(math.cos(angle) * 8, 2, math.sin(angle) * 8)
                        part.CFrame = base.CFrame * offset
                        task.wait(0.1)
                    end
                end)
                ctx.respond("Orbiting " .. target.Name)
            end
        end,
    })

    reg({
        name = "sparkles",
        description = "Add sparkles to a player.",
        category = "Fun",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            Util.withCharacter(target, function(character)
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        local s = Instance.new("Sparkles")
                        s.Parent = part
                        s.SparkleColor = Color3.fromRGB(0, 170, 255)
                        task.delay(10, function()
                            s:Destroy()
                        end)
                    end
                end
            end)
            ctx.respond("Sparkles added to " .. target.Name)
        end,
    })

    reg({
        name = "beacon",
        description = "Place a floating beacon above a player.",
        category = "Fun",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            if target and target.Character and target.Character.PrimaryPart then
                Util.addBillboard(target.Character.PrimaryPart, args[2] or "Beacon", Color3.fromRGB(0, 132, 255))
                ctx.respond("Beacon placed over " .. target.Name)
            end
        end,
    })

    reg({
        name = "trail",
        description = "Create a blue trail behind a player.",
        category = "Fun",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            Util.withCharacter(target, function(character)
                local attachment0 = Instance.new("Attachment")
                attachment0.Position = Vector3.new(0, 1, 0)
                attachment0.Parent = character.PrimaryPart
                local attachment1 = Instance.new("Attachment")
                attachment1.Position = Vector3.new(0, -1, 0)
                attachment1.Parent = character.PrimaryPart
                local trail = Instance.new("Trail")
                trail.Attachment0 = attachment0
                trail.Attachment1 = attachment1
                trail.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 132, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 50, 120)),
                })
                trail.Parent = character.PrimaryPart
                task.delay(30, function()
                    trail:Destroy()
                end)
            end)
            ctx.respond("Trail added to " .. target.Name)
        end,
    })

    reg({
        name = "ambient",
        description = "Set ambient lighting using RGB values.",
        category = "World",
        run = function(ctx, args)
            local r = tonumber(args[1]) or 20
            local g = tonumber(args[2]) or 20
            local b = tonumber(args[3]) or 20
            Util.colorPreset("custom", Color3.fromRGB(r, g, b))
        end,
    })

    reg({
        name = "fog",
        description = "Adjust fog distance (start, end).",
        category = "World",
        run = function(ctx, args)
            local start = tonumber(args[1]) or 0
            local finish = tonumber(args[2]) or 500
            Lighting.FogStart = start
            Lighting.FogEnd = finish
            ctx.respond("Fog set to " .. start .. " - " .. finish)
        end,
    })

    reg({
        name = "sky",
        description = "Apply a skybox asset id.",
        category = "World",
        run = function(ctx, args)
            local id = args[1]
            if not id then return end
            local sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
            sky.SkyboxBk = "rbxassetid://" .. id
            sky.SkyboxDn = "rbxassetid://" .. id
            sky.SkyboxFt = "rbxassetid://" .. id
            sky.SkyboxLf = "rbxassetid://" .. id
            sky.SkyboxRt = "rbxassetid://" .. id
            sky.SkyboxUp = "rbxassetid://" .. id
            sky.Parent = Lighting
            ctx.respond("Skybox updated.")
        end,
    })

    reg({
        name = "clean",
        description = "Remove loose hats and tools from workspace.",
        category = "Utility",
        run = function(ctx)
            local removed = 0
            for _, item in ipairs(workspace:GetChildren()) do
                if item:IsA("Tool") or item:IsA("Accoutrement") then
                    removed += 1
                    item:Destroy()
                end
            end
            ctx.respond("Cleaned " .. removed .. " loose items.")
        end,
    })

    reg({
        name = "sit",
        description = "Toggle sitting for a player.",
        category = "Action",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            local humanoid = Util.getHumanoid(target)
            if humanoid then
                humanoid.Sit = true
                ctx.respond(target.Name .. " is now sitting.")
            end
        end,
    })

    reg({
        name = "dance",
        description = "Play a dance animation.",
        category = "Fun",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            local humanoid = Util.getHumanoid(target)
            if humanoid then
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://507776043" -- Roblox dance
                local track = humanoid:LoadAnimation(animation)
                track:Play()
                task.delay(10, function()
                    track:Stop()
                end)
                ctx.respond(target.Name .. " is dancing.")
            end
        end,
    })

    reg({
        name = "jumpboost",
        description = "Briefly boost jump.",
        category = "Movement",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            local boost = tonumber(args[2]) or 100
            Util.applyPresetMotion(target, "JumpPower", boost)
            task.delay(5, function()
                Util.applyPresetMotion(target, "JumpPower", 50)
            end)
            ctx.respond(target.Name .. " jump boosted to " .. boost)
        end,
    })

    reg({
        name = "forcefield",
        description = "Give a player a temporary forcefield.",
        category = "Action",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            Util.withCharacter(target, function(character)
                local field = Instance.new("ForceField")
                field.Parent = character
                task.delay(15, function()
                    field:Destroy()
                end)
            end)
            ctx.respond(target.Name .. " has a forcefield.")
        end,
    })

    reg({
        name = "invisible",
        description = "Make a player invisible.",
        category = "Action",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            Util.withCharacter(target, function(character)
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                        if part:FindFirstChildOfClass("Decal") then
                            for _, decal in ipairs(part:GetDescendants()) do
                                if decal:IsA("Decal") then decal.Transparency = 1 end
                            end
                        end
                    end
                end
            end)
            ctx.respond(target.Name .. " is now invisible.")
        end,
    })

    reg({
        name = "visible",
        description = "Restore visibility to a player.",
        category = "Action",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            Util.withCharacter(target, function(character)
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                        for _, decal in ipairs(part:GetDescendants()) do
                            if decal:IsA("Decal") then decal.Transparency = 0 end
                        end
                    end
                end
            end)
            ctx.respond(target.Name .. " visibility restored.")
        end,
    })

    -- Speed presets (25)
    local speedPresets = {16, 20, 24, 28, 32, 36, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 110, 120, 130, 140, 150, 160}
    for _, preset in ipairs(speedPresets) do
        reg({
            name = "speed" .. preset,
            description = "Set walkspeed to " .. preset .. ".",
            category = "Movement Presets",
            run = function(ctx, args)
                local target = Util.findPlayer(args[1]) or ctx.player
                Util.applyPresetMotion(target, "WalkSpeed", preset)
                ctx.respond(target.Name .. " speed preset " .. preset .. " applied")
            end,
        })
    end

    -- Jump presets (25)
    local jumpPresets = {30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 175, 200, 225, 250, 275, 300, 325, 350, 375, 400, 450, 500}
    for _, preset in ipairs(jumpPresets) do
        reg({
            name = "jump" .. preset,
            description = "Set jumppower to " .. preset .. ".",
            category = "Movement Presets",
            run = function(ctx, args)
                local target = Util.findPlayer(args[1]) or ctx.player
                Util.applyPresetMotion(target, "JumpPower", preset)
                ctx.respond(target.Name .. " jump preset " .. preset .. " applied")
            end,
        })
    end

    -- Gravity presets (15)
    local gravityPresets = {196, 150, 120, 100, 80, 60, 40, 20, 10, 5, 2, 1, 0, 250, 300}
    for _, preset in ipairs(gravityPresets) do
        reg({
            name = "gravity" .. preset,
            description = "Set gravity to " .. preset .. ".",
            category = "World Presets",
            run = function(ctx)
                workspace.Gravity = preset
                ctx.respond("Gravity changed to " .. preset)
            end,
        })
    end

    -- Lighting color presets (20)
    local lightingPresets = {
        {"midnight", Color3.fromRGB(8, 10, 18)},
        {"storm", Color3.fromRGB(30, 40, 60)},
        {"ocean", Color3.fromRGB(0, 65, 120)},
        {"arctic", Color3.fromRGB(180, 200, 255)},
        {"bluelight", Color3.fromRGB(0, 132, 255)},
        {"royal", Color3.fromRGB(0, 50, 140)},
        {"neon", Color3.fromRGB(0, 255, 255)},
        {"onyx", Color3.fromRGB(20, 20, 20)},
        {"twilight", Color3.fromRGB(50, 70, 120)},
        {"moon", Color3.fromRGB(170, 190, 220)},
        {"dusk", Color3.fromRGB(60, 40, 70)},
        {"cyber", Color3.fromRGB(0, 200, 255)},
        {"ink", Color3.fromRGB(10, 10, 25)},
        {"darkblue", Color3.fromRGB(12, 34, 68)},
        {"glacier", Color3.fromRGB(180, 230, 255)},
        {"void", Color3.fromRGB(5, 5, 10)},
        {"aurora", Color3.fromRGB(15, 60, 120)},
        {"sapphire", Color3.fromRGB(0, 80, 200)},
        {"ultramarine", Color3.fromRGB(18, 10, 140)},
        {"eclipse", Color3.fromRGB(30, 30, 60)},
    }
    for _, preset in ipairs(lightingPresets) do
        local name, color = preset[1], preset[2]
        reg({
            name = "light" .. name,
            description = "Lighting preset: " .. name,
            category = "World Presets",
            run = function(ctx)
                Util.colorPreset(name, color)
            end,
        })
    end

    -- Music commands (40)
    local musicPresets = {
        {"lofi", "rbxassetid://1837956509"},
        {"synthwave", "rbxassetid://9045317386"},
        {"drift", "rbxassetid://9065059408"},
        {"focus", "rbxassetid://1841468057"},
        {"charge", "rbxassetid://1843524193"},
        {"boss", "rbxassetid://1843523046"},
        {"calm", "rbxassetid://1843523144"},
        {"midnight", "rbxassetid://1841468066"},
        {"space", "rbxassetid://1839242319"},
        {"retro", "rbxassetid://1843523962"},
        {"energy", "rbxassetid://1843523323"},
        {"bluepulse", "rbxassetid://9110549712"},
        {"zen", "rbxassetid://1843523119"},
        {"hype", "rbxassetid://1843523295"},
        {"battle", "rbxassetid://1843522994"},
        {"ambient", "rbxassetid://1843524240"},
        {"rain", "rbxassetid://9120261891"},
        {"piano", "rbxassetid://1843523147"},
        {"violin", "rbxassetid://1843523084"},
        {"mystery", "rbxassetid://1839242220"},
        {"city", "rbxassetid://1839242133"},
        {"ice", "rbxassetid://1837956514"},
        {"mountain", "rbxassetid://1843522873"},
        {"stealth", "rbxassetid://1843523088"},
        {"tech", "rbxassetid://1843523605"},
        {"pulse", "rbxassetid://1843523619"},
        {"drums", "rbxassetid://1843523284"},
        {"string", "rbxassetid://1843523306"},
        {"chill", "rbxassetid://1841468045"},
        {"vapor", "rbxassetid://1843523942"},
        {"dream", "rbxassetid://1843523987"},
        {"forest", "rbxassetid://1841468059"},
        {"desert", "rbxassetid://1843523920"},
        {"storm", "rbxassetid://1839242230"},
        {"lightning", "rbxassetid://1843523613"},
        {"timelapse", "rbxassetid://1843523901"},
        {"future", "rbxassetid://1843523596"},
        {"uplift", "rbxassetid://1843523244"},
        {"citynight", "rbxassetid://1843524234"},
        {"dive", "rbxassetid://1837956510"},
        {"flow", "rbxassetid://1843522879"},
    }
    for _, preset in ipairs(musicPresets) do
        local name, soundId = preset[1], preset[2]
        reg({
            name = "music" .. name,
            description = "Play music track " .. name,
            category = "Audio",
            run = function(ctx)
                Util.playSound("AdminMusic", soundId)
                ctx.respond("Now playing: " .. name)
            end,
        })
    end

    reg({
        name = "musicstop",
        description = "Stop the admin music track.",
        category = "Audio",
        run = function(ctx)
            Util.stopSound("AdminMusic")
            ctx.respond("Music stopped.")
        end,
    })

    reg({
        name = "panic",
        description = "Emergency stop: clears music, fires, and resets lighting.",
        category = "Audio",
        run = function(ctx)
            Util.stopSound("AdminMusic")
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Fire") or v:IsA("ParticleEmitter") then
                    v.Enabled = false
                end
            end
            Lighting.TimeOfDay = "12:00:00"
            Lighting.Brightness = 2
            ctx.respond("Panic cleanup applied.")
        end,
    })

    -- Announcement styles (15)
    local announcementStyles = {
        "alert", "warning", "info", "tip", "blue", "dark", "signal", "priority", "notify", "status", "event", "maintenance", "update", "drop", "boost",
    }
    for _, style in ipairs(announcementStyles) do
        reg({
            name = "announce" .. style,
            description = "Send a styled announcement: " .. style,
            category = "Communications",
            run = function(ctx, args)
                Util.sendSystemMessage("[" .. string.upper(style) .. "] " .. formatArgs(args))
            end,
        })
    end

    -- Color flash commands (15)
    local flashColors = {
        {"blue", Color3.fromRGB(0, 132, 255)},
        {"cyan", Color3.fromRGB(0, 255, 255)},
        {"navy", Color3.fromRGB(0, 35, 120)},
        {"midnight", Color3.fromRGB(8, 10, 18)},
        {"ice", Color3.fromRGB(180, 220, 255)},
        {"teal", Color3.fromRGB(0, 180, 180)},
        {"azure", Color3.fromRGB(0, 120, 255)},
        {"aqua", Color3.fromRGB(0, 200, 200)},
        {"wave", Color3.fromRGB(12, 90, 200)},
        {"storm", Color3.fromRGB(30, 40, 60)},
        {"dusk", Color3.fromRGB(80, 60, 140)},
        {"neon", Color3.fromRGB(0, 255, 200)},
        {"slate", Color3.fromRGB(60, 80, 110)},
        {"abyss", Color3.fromRGB(10, 15, 30)},
        {"shadow", Color3.fromRGB(20, 20, 30)},
    }
    for _, data in ipairs(flashColors) do
        reg({
            name = "flash" .. data[1],
            description = "Flash player outline in " .. data[1],
            category = "Effects",
            run = function(ctx, args)
                local target = Util.findPlayer(args[1]) or ctx.player
                Util.flash(target, data[2])
                ctx.respond("Flashed " .. target.Name .. " in " .. data[1])
            end,
        })
    end

    reg({
        name = "waypoint",
        description = "Save or teleport to a waypoint (add/list/tp).",
        category = "Movement",
        run = function(ctx, args)
            local sub = string.lower(args[1] or "")
            if sub == "add" then
                local name = args[2] or ("mark" .. tostring(#ctx.registry.waypoints + 1))
                local saved = Util.storeCFrame(ctx.player)
                if saved then
                    ctx.registry.waypoints[string.lower(name)] = saved
                    ctx.respond("Waypoint '" .. name .. "' stored.")
                end
            elseif sub == "list" then
                local names = {}
                for key, _ in pairs(ctx.registry.waypoints) do
                    table.insert(names, key)
                end
                ctx.respond("Waypoints: " .. table.concat(names, ", "))
            elseif sub == "tp" then
                local name = string.lower(args[2] or "")
                local cframe = ctx.registry.waypoints[name]
                local target = Util.findPlayer(args[3]) or ctx.player
                if cframe and target then
                    Util.teleportToCFrame(target, cframe)
                    ctx.respond(target.Name .. " moved to waypoint '" .. name .. "'")
                end
            else
                ctx.respond("Usage: waypoint add <name> | waypoint list | waypoint tp <name> [player]")
            end
        end,
    })

    -- Teleport pads (15)
    local teleportLocations = {
        {"spawn", CFrame.new(0, 10, 0)},
        {"sky", CFrame.new(0, 500, 0)},
        {"arena", CFrame.new(100, 10, 100)},
        {"dock", CFrame.new(-150, 10, 80)},
        {"temple", CFrame.new(250, 10, -120)},
        {"tower", CFrame.new(0, 150, -50)},
        {"bridge", CFrame.new(80, 10, -200)},
        {"forest", CFrame.new(-220, 10, -120)},
        {"cave", CFrame.new(160, -10, 260)},
        {"lab", CFrame.new(-60, 10, 240)},
        {"hangar", CFrame.new(320, 20, 30)},
        {"vault", CFrame.new(-320, 10, 10)},
        {"beach", CFrame.new(40, 8, 340)},
        {"citadel", CFrame.new(-10, 200, -10)},
        {"plaza", CFrame.new(20, 10, 20)},
    }
    for _, location in ipairs(teleportLocations) do
        local name, cframe = location[1], location[2]
        reg({
            name = "warp" .. name,
            description = "Warp player to " .. name,
            category = "Movement",
            run = function(ctx, args)
                local target = Util.findPlayer(args[1]) or ctx.player
                Util.teleportToCFrame(target, cframe)
                ctx.respond(target.Name .. " warped to " .. name)
            end,
        })
    end

    -- Inventory utilities (10)
    reg({
        name = "clearinventory",
        description = "Clear a player's backpack.",
        category = "Utility",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            local backpack = target:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    item:Destroy()
                end
            end
            ctx.respond(target.Name .. " inventory cleared.")
        end,
    })

    reg({
        name = "giveflashlight",
        description = "Give a simple flashlight tool.",
        category = "Utility",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            local backpack = target:FindFirstChildOfClass("Backpack")
            local tool = Instance.new("Tool")
            tool.Name = "Flashlight"
            tool.RequiresHandle = true
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(1, 1, 2)
            handle.Color = Color3.fromRGB(10, 10, 10)
            handle.Parent = tool
            local light = Instance.new("SpotLight")
            light.Angle = 80
            light.Brightness = 2
            light.Range = 30
            light.Color = Color3.fromRGB(0, 140, 255)
            light.Parent = handle
            tool.Parent = backpack
            ctx.respond(target.Name .. " received a flashlight.")
        end,
    })

    reg({
        name = "giveshield",
        description = "Give a reusable shield forcefield tool.",
        category = "Utility",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            local backpack = target:FindFirstChildOfClass("Backpack")
            local tool = Instance.new("Tool")
            tool.Name = "Shield"
            tool.RequiresHandle = false
            tool.Activated:Connect(function()
                local character = target.Character
                if character then
                    local field = Instance.new("ForceField")
                    field.Parent = character
                    task.delay(8, function()
                        field:Destroy()
                    end)
                end
            end)
            tool.Parent = backpack
            ctx.respond(target.Name .. " received a shield.")
        end,
    })

    reg({
        name = "givegrappler",
        description = "Give a simple grappler tool.",
        category = "Utility",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            local backpack = target:FindFirstChildOfClass("Backpack")
            local tool = Instance.new("Tool")
            tool.Name = "Grappler"
            tool.RequiresHandle = false
            tool.Activated:Connect(function()
                local character = target.Character
                if character and character.PrimaryPart then
                    local ray = Ray.new(character.PrimaryPart.Position, character.PrimaryPart.CFrame.LookVector * 150)
                    local part, position = workspace:FindPartOnRay(ray, character)
                    if part and position then
                        character:SetPrimaryPartCFrame(CFrame.new(position + Vector3.new(0, 5, 0)))
                    end
                end
            end)
            tool.Parent = backpack
            ctx.respond(target.Name .. " received a grappler.")
        end,
    })

    reg({
        name = "clone",
        description = "Clone your character as a dummy.",
        category = "Utility",
        run = function(ctx)
            local character = ctx.player.Character
            if character then
                local clone = character:Clone()
                clone.Name = ctx.player.Name .. "_clone"
                clone.Parent = workspace
                for _, part in ipairs(clone:GetDescendants()) do
                    if part:IsA("Script") or part:IsA("LocalScript") then
                        part:Destroy()
                    end
                end
                ctx.respond("Created clone for " .. ctx.player.Name)
            end
        end,
    })

    reg({
        name = "platform",
        description = "Spawn a personal platform.",
        category = "Utility",
        run = function(ctx)
            local character = ctx.player.Character
            if character and character.PrimaryPart then
                local platform = Instance.new("Part")
                platform.Anchored = true
                platform.Size = Vector3.new(10, 1, 10)
                platform.Color = Color3.fromRGB(0, 132, 255)
                platform.Material = Enum.Material.Neon
                platform.CFrame = character.PrimaryPart.CFrame * CFrame.new(0, -3, 0)
                platform.Name = ctx.player.Name .. "_platform"
                platform.Parent = workspace
                task.delay(30, function()
                    platform:Destroy()
                end)
                ctx.respond("Platform spawned.")
            end
        end,
    })

    reg({
        name = "shieldwall",
        description = "Place a temporary shield wall.",
        category = "Utility",
        run = function(ctx)
            local character = ctx.player.Character
            if character and character.PrimaryPart then
                local wall = Instance.new("Part")
                wall.Size = Vector3.new(12, 12, 1)
                wall.Anchored = true
                wall.Color = Color3.fromRGB(0, 132, 255)
                wall.Material = Enum.Material.ForceField
                wall.CFrame = character.PrimaryPart.CFrame * CFrame.new(0, 0, -8)
                wall.Parent = workspace
                task.delay(20, function()
                    wall:Destroy()
                end)
                ctx.respond("Shield wall placed.")
            end
        end,
    })

    reg({
        name = "spotlight",
        description = "Create a spotlight above the player.",
        category = "Utility",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            Util.withCharacter(target, function(character)
                local light = Instance.new("PointLight")
                light.Color = Color3.fromRGB(0, 132, 255)
                light.Brightness = 5
                light.Range = 25
                light.Parent = character.PrimaryPart
                task.delay(15, function()
                    light:Destroy()
                end)
            end)
            ctx.respond("Spotlight created for " .. target.Name)
        end,
    })

    reg({
        name = "resetcamera",
        description = "Reset player's camera to default.",
        category = "Utility",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            local camera = workspace.CurrentCamera
            if camera then
                camera.CameraSubject = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
                camera.CameraType = Enum.CameraType.Custom
                ctx.respond(target.Name .. " camera reset.")
            end
        end,
    })

    -- Status toggles (10)
    local statuses = {
        {"god", function(target)
            Util.withCharacter(target, function(character)
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                end
            end)
        end},
        {"ungod", function(target)
            Util.withCharacter(target, function(character)
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = 100
                    humanoid.Health = humanoid.MaxHealth
                end
            end)
        end},
        {"anchor", function(target)
            Util.withCharacter(target, function(character)
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                    end
                end
            end)
        end},
        {"unanchor", function(target)
            Util.withCharacter(target, function(character)
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                    end
                end
            end)
        end},
        {"fly", function(target)
            Util.applyPresetMotion(target, "WalkSpeed", 100)
            Util.applyPresetMotion(target, "JumpPower", 100)
        end},
        {"unfly", function(target)
            Util.applyPresetMotion(target, "WalkSpeed", 16)
            Util.applyPresetMotion(target, "JumpPower", 50)
        end},
        {"noclip", function(target)
            Util.ensureTag(target, "AdminNoClip")
        end},
        {"clip", function(target)
            Util.ensureTag(target, "AdminNoClipOff")
        end},
        {"slow", function(target)
            Util.applyPresetMotion(target, "WalkSpeed", 8)
        end},
        {"superjump", function(target)
            Util.applyPresetMotion(target, "JumpPower", 500)
        end},
    }
    for _, status in ipairs(statuses) do
        reg({
            name = status[1],
            description = "Toggle status " .. status[1],
            category = "Status",
            run = function(ctx, args)
                local target = Util.findPlayer(args[1]) or ctx.player
                status[2](target)
                ctx.respond(status[1] .. " applied to " .. target.Name)
            end,
        })
    end

    -- Generated emote commands (20)
    local emotes = {
        "cheer", "laugh", "point", "wave", "salute", "tilt", "bow", "applaud", "think", "nod", "shake", "dance2", "dance3", "belly", "float", "air", "hero", "idle", "stretch", "groove",
    }
    for _, emote in ipairs(emotes) do
        reg({
            name = "emote" .. emote,
            description = "Play emote " .. emote,
            category = "Fun",
            run = function(ctx, args)
                local target = Util.findPlayer(args[1]) or ctx.player
                local humanoid = Util.getHumanoid(target)
                if humanoid then
                    humanoid:PlayEmote(emote)
                end
                ctx.respond(target.Name .. " emote: " .. emote)
            end,
        })
    end

    -- Weather/atmosphere presets (15)
    local atmospheres = {
        {"clear", Color3.fromRGB(0, 132, 255), 0.1},
        {"haze", Color3.fromRGB(60, 80, 120), 0.3},
        {"smog", Color3.fromRGB(70, 70, 70), 0.6},
        {"neonblue", Color3.fromRGB(0, 255, 255), 0.05},
        {"dark", Color3.fromRGB(10, 10, 20), 0.5},
        {"storm", Color3.fromRGB(20, 40, 80), 0.7},
        {"glass", Color3.fromRGB(120, 180, 255), 0.05},
        {"aqua", Color3.fromRGB(0, 140, 180), 0.2},
        {"shadow", Color3.fromRGB(20, 20, 30), 0.4},
        {"mint", Color3.fromRGB(100, 220, 200), 0.1},
        {"abyss", Color3.fromRGB(5, 5, 10), 0.8},
        {"permafrost", Color3.fromRGB(200, 230, 255), 0.2},
        {"glow", Color3.fromRGB(0, 200, 255), 0.15},
        {"orbit", Color3.fromRGB(0, 80, 200), 0.25},
        {"midnight", Color3.fromRGB(0, 30, 80), 0.5},
    }
    for _, atmosphere in ipairs(atmospheres) do
        local name, color, density = atmosphere[1], atmosphere[2], atmosphere[3]
        reg({
            name = "atmo" .. name,
            description = "Atmosphere preset " .. name,
            category = "World Presets",
            run = function(ctx)
                local atmo = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
                atmo.Color = color
                atmo.Density = density
                atmo.Parent = Lighting
                ctx.respond("Atmosphere set to " .. name)
            end,
        })
    end

    -- Scoreboard controls (10)
    local badges = {"admin", "builder", "vip", "mod", "tester", "champion", "support", "friend", "elite", "pilot"}
    for _, badge in ipairs(badges) do
        reg({
            name = "tag" .. badge,
            description = "Add a chat tag: " .. badge,
            category = "Communications",
            run = function(ctx, args)
                local target = Util.findPlayer(args[1]) or ctx.player
                target:SetAttribute("ChatTag", string.upper(badge))
                ctx.respond("Tag added to " .. target.Name .. ": " .. badge)
            end,
        })
    end

    reg({
        name = "untag",
        description = "Remove chat tag attribute.",
        category = "Communications",
        run = function(ctx, args)
            local target = Util.findPlayer(args[1]) or ctx.player
            target:SetAttribute("ChatTag", nil)
            ctx.respond("Tags cleared for " .. target.Name)
        end,
    })

    -- Safe shutdown (1)
    reg({
        name = "shutdown",
        description = "Notify players and shutdown server.",
        category = "Utility",
        run = function(ctx)
            Util.sendSystemMessage("Server shutting down by admin.")
            for _, player in ipairs(Players:GetPlayers()) do
                player:Kick("Server shutting down for maintenance.")
            end
        end,
    })
end

function CommandRegistry:handle(player, message)
    local prefix = self.config.CommandPrefix
    if string.sub(message, 1, #prefix) ~= prefix then
        return
    end

    if self.banList[player.UserId] == true then
        player:Kick("You are banned from this server.")
        return
    end

    local expiry = tonumber(self.banList[player.UserId])
    if expiry and tick() > expiry then
        self.banList[player.UserId] = nil
    elseif expiry then
        player:Kick("You are temporarily banned.")
        return
    end

    if self.muted[player.UserId] then
        return
    end

    local withoutPrefix = string.sub(message, #prefix + 1)
    local tokens = string.split(withoutPrefix, " ")
    local commandName = tokens[1]
    table.remove(tokens, 1)
    local command = self:get(commandName)
    if not command then
        return
    end

    local now = tick()
    local last = self.cooldowns[player.UserId]
    if last and (now - last) < (self.config.Moderation.CommandCooldownSeconds or 0) then
        return
    end
    self.cooldowns[player.UserId] = now

    if not requireAdmin(player, self) then
        player:Kick("Unauthorized access to admin commands.")
        return
    end

    local ctx = commandContext(player, message, self)
    command.run(ctx, tokens)
    self:pushHistory(player, command.name, tokens)
end

return CommandRegistry
