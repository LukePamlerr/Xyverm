local HttpService = game:GetService("HttpService")

local AI = {}

function AI.generate(config, prompt)
    if not config.Enabled then
        return "AI is disabled in configuration."
    end

    local payload = {
        model = config.Model,
        messages = {
            { role = "system", content = config.SystemPrompt },
            { role = "user", content = prompt },
        },
        max_tokens = 100,
        temperature = 0.6,
    }

    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = config.Endpoint,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer " .. config.ApiKey,
            },
            Body = HttpService:JSONEncode(payload),
        })
    end)

    if not success or not response.Success then
        return "AI request failed: " .. (success and response.StatusMessage or "unknown error")
    end

    local decoded = HttpService:JSONDecode(response.Body)
    if decoded and decoded.choices and decoded.choices[1] and decoded.choices[1].message then
        return decoded.choices[1].message.content
    end

    return "AI response was empty."
end

return AI
