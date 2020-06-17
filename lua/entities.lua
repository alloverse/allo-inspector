local ffi = require("ffi")

function draw(w, ig)
  ig.SetNextWindowSize(ig.ImVec2(400,400), ffi.C.ImGuiCond_FirstUseEver)
  ig.Begin("Entities in "..w.client.placename)

  ig.Columns(3, "entities")
  ig.Separator()
  ig.Text("ID"); ig.NextColumn()
  ig.Text("Position"); ig.NextColumn()
  ig.Text("Components"); ig.NextColumn()
  ig.Separator();

  for eid, entity in pairs(w.client.state.entities) do
    local m = entity.components.transform and entity.components.transform.matrix or nil
    local v = m and {m[13], m[14], m[15]} or {0, 0, 0}

    ig.Text(entity.id); ig.NextColumn()
    ig.Text(string.format("%.2f %.2f %.2f", v[1], v[2], v[3])); ig.NextColumn()
    ig.Button("Show"); ig.NextColumn()
  end

  ig.End()
end

return function(client)
    return {
        client = client,
        draw = draw
    }
end
