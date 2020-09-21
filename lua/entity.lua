local ffi = require("ffi")
local pretty = require("pl.pretty")
local mat4 = require "cpml.mat4"

function drawEntity(w, ig)
  local e = w.client.state.entities[w.eid]
  ig.SetNextWindowSize(ig.ImVec2(200,400), ffi.C.ImGuiCond_FirstUseEver)
  ig.Begin(w.eid.." in "..w.client.placename)

  local comps = e.components

  ig.Columns(2, w.eid.."_components")
  ig.Separator()
  ig.Text("key"); ig.NextColumn()
  ig.Text("value"); ig.NextColumn()
  ig.Separator();

  for key, comp in pairs(comps) do
    ig.Text(key); ig.NextColumn()
    if key == "transform" then
        -- transpose because to_string doesn't correctly do it :S
        local m = mat4.new(comp.matrix); mat4.transpose(m, m)
        ig.Text(mat4.to_string(m))
    else
        ig.Text(pretty.write(comp)); 
    end
    ig.NextColumn()
    ig.Separator()
  end

  ig.End()
end

return function(client, eid)
    return {
        client = client,
        draw = drawEntity,
        eid = eid,
    }
end
