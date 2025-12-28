# Xyverm Roblox Admin Panel

This repository contains a full Roblox admin system written in Lua with 200+ real commands, AI-assisted responses, and a black/blue themed UI for easy control inside Roblox Studio.

## Structure
- `AdminPanel/Config.lua` — tweak command prefix, admin UserIds, AI backend, cooldowns, logging, and theme colors.
- `AdminPanel/Commands.lua` — command registry with 200+ actions (moderation, movement presets, lighting, music, effects, and more).
- `AdminPanel/ServerMain.lua` — server-side bootstrap script that wires chat/RemoteEvents and executes commands.
- `AdminPanel/ClientUI.lua` — local UI panel script with black + blue styling, command browser, and quick toggle key.
- `AdminPanel/Util.lua` — shared helpers for messaging, lighting, teleporting, sounds, etc.
- `AdminPanel/AI.lua` — HTTP integration for AI chat completions (configure your endpoint/key before use).

## Installation (Roblox Studio)
1. Add a **Folder** named `AdminPanel` under `ReplicatedStorage` and copy all Lua files from this repository into it.
2. Place `ServerMain.lua` as a **Script** inside **ServerScriptService**.
3. Place `ClientUI.lua` as a **LocalScript** inside **StarterPlayerScripts**.
4. Update `Config.lua`:
   - Replace `YOUR_API_KEY` and optionally the AI endpoint/model.
   - Set `CommandPrefix` and add admin UserIds as needed.
5. Play-test in Studio. Use chat with the prefix (default `!`) or the in-game UI to trigger commands.

## Highlights
- **200+ commands** across moderation, movement, audio, effects, world presets, waypoints, beacons, shields, panic cleanup, and history.
- **AI integration** via `ai <prompt>` calling your configured HTTP endpoint.
- **Black/blue UI** with quick-run button, searchable command list, toggle keybind, and log feed.
- **No mock data**—every command performs a concrete action (kick, ban, warp, lighting, audio, etc.).

## Notes
- Some commands interact with services like `TextChatService`, `SoundService`, and `Lighting`; enable these in Studio.
- The AI endpoint requires an accessible HTTPS service; Roblox must be allowed to send HTTP requests.
- For security, set admin IDs before publishing and keep API keys secret using Studio configuration.
