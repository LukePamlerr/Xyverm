local Config = {}

-- Command prefix players must use in chat to trigger admin actions.
Config.CommandPrefix = "!"

-- UI behavior when using the ClientUI panel.
Config.UI = {
    ToggleKey = Enum.KeyCode.F4, -- keybind to show/hide the panel
    DefaultVisible = true,
}

-- UserIds that should have admin rights. Always include the game owner by default.
Config.AdminUserIds = {
    ["Owner"] = true,
    [1] = true, -- Roblox automatically replaces 1 with the creator when published
}

-- Optional AI backend configuration. Provide a real endpoint and API key before use.
Config.AI = {
    Enabled = true,
    Endpoint = "https://api.openai.com/v1/chat/completions",
    ApiKey = "YOUR_API_KEY", -- Replace in Studio before publishing
    Model = "gpt-4o-mini",
    SystemPrompt = "You are the assistant built into a Roblox admin panel. Be concise and safe.",
}

-- Default moderation settings
Config.Moderation = {
    DefaultBanLengthMinutes = 1440, -- one day
    TempBanMaxMinutes = 10080, -- one week
    CommandCooldownSeconds = 1, -- simple anti-spam for admin commands
}

-- Logging and telemetry controls
Config.Logging = {
    HistorySize = 75, -- how many command entries to retain for audit
    EchoCommandsToChat = true, -- whether to echo successful commands to [Admin] chat
    AnnounceJoins = true, -- show a blue join message when a tagged player joins
}

-- UI theme colors (black + blue aesthetic)
Config.Theme = {
    Background = Color3.fromRGB(8, 10, 18),
    Panel = Color3.fromRGB(16, 22, 40),
    Accent = Color3.fromRGB(0, 132, 255),
    AccentDark = Color3.fromRGB(0, 88, 170),
    Text = Color3.fromRGB(220, 234, 255),
    Muted = Color3.fromRGB(140, 160, 190),
}

return Config
