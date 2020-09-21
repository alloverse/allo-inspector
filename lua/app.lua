local ffi = require "ffi"
local connection = require "connection"

function drawConnect(w, ig)
    ig.SetNextWindowSize(ig.ImVec2(420,120), ffi.C.ImGuiCond_FirstUseEver)
    ig.Begin("Connect")

    ig.Text("Input an alloplace:// url to connect to to introspect it.")
    ig.InputText("URL", w.connect_to, 256, 0, nil, nil) 

    if ig.Button("Connect") then
        w.openWindow(connection(ffi.string(w.connect_to)))
    end
    ig.End()
end
function connectWindow()
    return {
        draw = drawConnect,
        connect_to = ffi.new("char[256]", "alloplace://nevyn.places.alloverse.com")
    }
end

local windows = {}

function closeWindow(w)
    for i, x in ipairs(windows) do
        if x == w then
            table.remove(windows, i)
            return
        end
    end
end

function openWindow(w)
    table.insert(windows, w)
    w.openWindow = openWindow
    w.closeWindow = closeWindow
end

openWindow(connectWindow())

local function draw(ig)
    for i, w in ipairs(windows) do
        w:draw(ig)
    end
end


return {
    draw = draw
}
