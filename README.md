# Vanta UI Library

Vanta is a lightweight and customizable user interface library for Roblox. Built by Kuro, it provides a clean and modern foundation for creating script hubs and interactive menus.

The design focuses on simplicity, clear layouts, and high performance without relying on heavy textures or bloated code.

## Features

- **Clean Aesthetic:** Dark theme by default with consistent padding and rounded corners.
- **Smooth Animations:** Built-in hover and transition effects using TweenService.
- **Global Search:** Top bar search functionality that filters elements across all tabs.
- **Theming System:** Easy color and font management through a central theme manager.
- **Notifications:** Built-in toast notifications that anchor to the bottom right of the screen.
- **Modular Codebase:** Object-oriented API that is easy to read and integrate.

## Usage

To use Vanta, require the library via GitHub using `loadstring`:

```lua
local Vanta = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kuro0975/Vanta-UI/refs/heads/main/Vanta.lua"))()

-- Create the main window
local Window = Vanta.CreateWindow({
    Title = "Vanta Hub",
    Profile = {
        Name = "Kuro",
        Status = "Developer"
    }
})

-- Create a Tab and Section
local MainTab = Window.CreateTab({ Name = "Main" })
local CombatSection = MainTab.CreateSection("Combat Settings")

-- Add a Toggle
CombatSection.CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(state)
        if state then
            Vanta.Notify({ Title = "System", Content = "Aimbot Enabled!" })
        end
    end
})
