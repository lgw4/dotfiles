-- Modules
local fnutils = require "hs.fnutils"
local fs = require "hs.fs"
local grid = require "hs.grid"
local hotkey = require "hs.hotkey"
local screen = require "hs.screen"
local window = require "hs.window"

-- Modifier keys
local mod = { "control", "command" }
local mod_shift = { "control", "command", "shift" }

-- Spoons
hs.loadSpoon("SpoonInstall")
if not (
    fs.attributes("/Applications/Amphetamine.app") or
    fs.attributes("/Applications/KeepingYouAwake.app") or
    fs.attributes("/Applications/Lungo.app")
    ) then
    spoon.SpoonInstall:andUse("Caffeine", {
        hotkeys = { toggle = { mod, "C" } },
        start = true
    })
end
if not (
    fs.attributes("/Applications/Disk Master.app") or
    fs.attributes("/Applications/Jettison.app")
    ) then
    spoon.SpoonInstall:andUse("EjectMenu", {
        config = {
            eject_on_lid_close = false,
            notify = true,
            show_in_menu_bar = true,
        },
        hotkeys = { ejectAll = { mod_shift, "E" } },
        start = true
    })
end
spoon.SpoonInstall:andUse("MouseCircle", {
    config = {
        color = {
            alpha = 0.75,
            blue = 0.0,
            green = 0.6,
            red = 0.521568627
        }
    },
    hotkeys = { show = { mod_shift, "D" } },
})
spoon.SpoonInstall:andUse("ReloadConfiguration", {
    hotkeys = { reloadConfiguration = { mod_shift, "R" } },
    hs.notify.new({ title = "Hammerspoon", informativeText = "Configuration loaded." }):send(),
    start = true
})

-- Get list of screens and refresh that list whenever screens are plugged or unplugged:
local screens = screen.allScreens()
local screenwatcher = screen.watcher.new(
    function() screens = screen.allScreens() end)
screenwatcher:start()

-- Default grid settings
grid.GRIDWIDTH = 12
grid.GRIDHEIGHT = 6
grid.MARGINX = 0
grid.MARGINY = 0
grid.ui.textSize = 36

-- Set display grid depending on resolution
for index, display in pairs(screen.allScreens()) do
    if display:frame().w / display:frame().h > 2 then
        -- 16 x 8 for ultrawide display
        grid.setGrid("16 x 8", display)
    else
        if display:frame().w < display:frame().h then
            -- 6 x 12 for vertically aligned display
            grid.setGrid("6 x 12", display)
        else
            -- 12 x 6 for normal display
            grid.setGrid("12 x 6", display)
        end
    end
end

-- Disable animation
window.animationDuration = 0

-- Original position of moved windows
local original_position = {}

-- Reset the original position when window is restored or closed
local function resetWindowPosition(_, _, _, id) original_position[id] = nil end

-- Move window to edge or back
local function moveWindow(direction)
    local win = window.frontmostWindow()
    local res = screen.mainScreen():frame()
    local id = win:id()

    if not original_position[id] then
        -- Move window to edge if no original position is stored in
        -- original_position for this window id
        local f = win:frame()
        original_position[id] = win:frame()
        -- Add watcher so we can reset the original_position if window is closed
        local watcher = win:newWatcher(resetWindowPosition, id)
        watcher:start({ hs.uielement.watcher.elementDestroyed })
        if direction == "left" then f.x = (res.w - (res.w * 2)) + 10 end
        if direction == "right" then f.x = (res.w + res.w) - 10 end
        if direction == "down" then f.y = (res.h + res.h) - 10 end
        win:setFrame(f)
    else
        -- Restore window if there is a value for original_position
        win:setFrame(original_position[id])
        -- Reset the original_position value
        resetWindowPosition(_, _, _, id)
    end
end

hotkey.bind(mod, "A", function() moveWindow("left") end)
hotkey.bind(mod, "D", function() moveWindow("right") end)
hotkey.bind(mod, "S", function() moveWindow("down") end)

-- Center frontmost window
function CenterWindow()
    local win = window.frontmostWindow()

    win:centerOnScreen(ensureInScreenBounds)
end

-- Move frontmost window down 100 pixels
function Down100Pixels()
    local win = hs.window.frontmostWindow()
    local f = win:frame()
    f.y = 100
    win:setFrameInScreenBounds(f)
end

-- Set size of frontmost window to w x h
function SetWindowSize(w, h)
    local win = window.frontmostWindow()
    local size = hs.geometry.size(w, h)
    win:setSize(size)
end

-- Center frontmost window
hotkey.bind(mod, "=", function() CenterWindow() end)

-- Center frontmost window macOS-style
hotkey.bind(mod_shift, "=", function()
    CenterWindow()
    Down100Pixels()
end)

-- Set dimensions of frontmost window
hotkey.bind(mod_shift, "1", function() SetWindowSize(1024, 768) end)
hotkey.bind(mod_shift, "2", function() SetWindowSize(1280, 720) end)
hotkey.bind(mod_shift, "3", function() SetWindowSize(1366, 768) end)
hotkey.bind(mod_shift, "5", function() SetWindowSize(1152, 864) end)
hotkey.bind(mod_shift, "6", function() SetWindowSize(640, 480) end)
hotkey.bind(mod_shift, "8", function() SetWindowSize(800, 600) end)
hotkey.bind(mod_shift, "F", function() SetWindowSize(720, 539) end)

-- Move windows
hotkey.bind(mod, "DOWN", grid.pushWindowDown)
hotkey.bind(mod, "UP", grid.pushWindowUp)
hotkey.bind(mod, "LEFT", grid.pushWindowLeft)
hotkey.bind(mod, "RIGHT", grid.pushWindowRight)

-- Move windows across screens
hotkey.bind(mod, "N", grid.pushWindowNextScreen)
hotkey.bind(mod, "P", grid.pushWindowPrevScreen)

-- Resize windows
hotkey.bind(mod_shift, "UP", grid.resizeWindowShorter)
hotkey.bind(mod_shift, "DOWN", grid.resizeWindowTaller)
hotkey.bind(mod_shift, "RIGHT", grid.resizeWindowWider)
hotkey.bind(mod_shift, "LEFT", grid.resizeWindowThinner)

-- Snap windows
hotkey.bind(mod, ";",
    function() grid.snap(window.frontmostWindow()) end)
hotkey.bind(mod, "'",
    function() fnutils.map(window.visibleWindows(), grid.snap) end)
