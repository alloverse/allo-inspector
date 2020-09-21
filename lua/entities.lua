local ffi = require("ffi")
local entityw = require "entity"
local mat4 = require "cpml.mat4"
local vec3 = require "cpml.vec3"

function drawEntities(w, ig)
  ig.SetNextWindowSize(ig.ImVec2(400,400), ffi.C.ImGuiCond_FirstUseEver)

  local open = ffi.new("bool[1]", true)
  ig.Begin("Entities in "..w.client.placename, open)
  if open[0] == false then
    w:closeWindow()
    ig.End()
    return
  end

  ig.Columns(5, "entities")
  ig.Separator()
  ig.Text("ID"); ig.NextColumn()
  ig.Text("Position"); ig.NextColumn()
  ig.Text("Parent"); ig.NextColumn()
  ig.Text("Pose"); ig.NextColumn()
  ig.Text("Components"); ig.NextColumn()
  ig.Separator();

  for eid, entity in pairs(w.client.state.entities) do
    local ml = entity.components.transform and entity.components.transform.matrix or nil
    local m = mat4.new(ml)
    local v = m * vec3.new(0,0,0)

    local rels = entity.components.relationships and entity.components.relationships or {}
    local intent = entity.components.intent and entity.components.intent or {}

    ig.Text(entity.id); ig.NextColumn()
    ig.Text(string.format("%.2f %.2f %.2f", v.x, v.y, v.z)); ig.NextColumn()
    ig.Text(string.format("%s", rels.parent)); ig.NextColumn()
    ig.Text(string.format("%s", intent.actuate_pose)); ig.NextColumn()

    if ig.Button("Inspect "..eid) then
        print("Inspecting", eid)
        w.openWindow(entityw(w.client, eid))
    end
    ig.NextColumn()
  end

  ig.End()
end

return function(client)
    return {
        client = client,
        draw = drawEntities
    }
end
