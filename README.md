# 🔋 Unlimited Power Priority

A World of Warcraft addon for Priests who want full control over **Power Infusion**. Designed with raiders and M+ players in mind, Unlimited Power Priority makes it easy to assign and manage PI targets without the hassle — and without breaking Blizzard’s secure UI rules.

---

## ✨ Features

- ✅ One-click secure Power Infusion macro generation
- 🧠 Auto-fallback to focus or self if target is unavailable
- 🖱️ Simple UI to assign and change targets pre-combat
- 💬 Customizable chat announcements (whisper, say, party, raid)
- 📍 Minimap button to quickly access target and config windows
- 🔄 “Recreate Macro” and “Reset to Defaults” utilities

---

## 🚀 Getting Started

1. **Install the addon**  
   Drop the `UnlimitedPowerPriority` folder into your `Interface/AddOns/` directory.

2. **Load into WoW**  
   Type `/upp` to open the target selection window.

3. **Assign your PI target**  
   Use the UI to select a player. A macro will be generated automatically.

4. **Drag the macro button**  
   From the settings window, drag the action button to your bar.

5. **Smite with confidence**  
   The macro will:
   - Cast on your selected target if valid
   - Fallback to focus if not
   - Fallback to yourself if no one else is valid

---

## 🔧 Slash Commands

| Command         | Description                     |
|-----------------|---------------------------------|
| `/upp`          | Open the target window          |
| `/upp config`   | Open settings                   |
| `/upp macro `   | Recreate the macro              |
| `/upp minimap ` | Toggle minimap icon             |
| `/upp help`     | Show all available commands     |

---

## 💡 Tips

- Change your PI target any time **before combat starts**
- Use `{name}` in the announcement text to insert the target's name
- Hide the minimap button in settings if you prefer a clean UI

---

## 📦 Dependencies

This addon uses:
- [LibDataBroker-1.1](https://www.wowace.com/projects/libdatabroker-1-1)
- [LibDBIcon-1.0](https://www.wowace.com/projects/libdbicon-1-0)

Both are included and loaded via the `.toc`.

---

## 🙏 Credits

Created by Ndika-Lightbringer
Special thanks to your raid team for tolerating me messing up their parses.

---

## 🛠️ License

MIT License. See `LICENSE` for details.
