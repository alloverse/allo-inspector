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

local connect_to = ffi.new("char[256]", "alloplace://nevyn.places.alloverse.com")
function draw(ig)
  if app == nil then
    ig.Begin("Connect")

    ig.Text(error and error or "Input an alloplace:// url to connect to to introspect it.")
    ig.InputText("URL", connect_to, 256, 0, nil, nil) 

    if ig.Button("Connect") then
        connect(ffi.string(connect_to))
    end
    ig.End()
  else
    client.client:poll()
    drawEntities(ig)
  end
end

function drawEntities(ig)
  ig.Begin("Entities")

  ig.Columns(3, "entities")
  ig.Separator()
  ig.Text("ID"); ig.NextColumn()
  ig.Text("Position"); ig.NextColumn()
  ig.Text("Components"); ig.NextColumn()
  ig.Separator();

  for eid, entity in pairs(client.state.entities) do
    local m = entity.components.transform and entity.components.transform.matrix or nil
    local v = m and {m[13], m[14], m[15]} or {0, 0, 0}

    ig.Text(entity.id); ig.NextColumn()
    ig.Text(string.format("%.2f %.2f %.2f", v[1], v[2], v[3])); ig.NextColumn()
    ig.Button("Show"); ig.NextColumn()
  end

  ig.End()
end

return {
    draw = draw
}