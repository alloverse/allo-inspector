local ffi = require "ffi"

local client = nil
local app = nil
local error = nil

function connect(to)
  client = Client(to, "inspector")
  if client:connect({dummy={dummy=0}}) == true then
    app = App(client)
  else
    client = nil
    error = "Failed to connect."
  end
end

local connect_to = ffi.new("char[256]")
function draw(ig)
  if app == nil then
    ig.Begin("Connect")

    ig.Text(error and error or "Input an alloplace:// url to connect to to introspect it.")
    ig.InputText("URL", connect_to, 256, 0, nil, nil) 

    if ig.Button("Connect") then
        connect(ffi.string(connect_to))
    end
    ig.End()
  end
end

return {
    draw = draw
}