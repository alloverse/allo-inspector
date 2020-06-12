local ffi = require "ffi"

local client = nil
local app = nil
local error = nil

function connect(to)
  client = Client(to, "inspector")
  if client:connect({dummy={dummy=0}}) == true then
    app = App(client)
    client.client:set_audio_callback(onAudio)
  else
    client = nil
    error = "Failed to connect."
  end
end


local tracks = {}
function onAudio(trackId, audio)
  local track = tracks[trackId]
  local sampleCount = #audio / 2
  if track == nil then
    track = {
      xs = ffi.new("float[?]", sampleCount),
      ysi = ffi.new("short[?]", sampleCount),
      ys = ffi.new("float[?]", sampleCount),
      count = sampleCount
    }
    for i = 0,track.count-1 do
      track.xs[i] = i
    end
    tracks[trackId] = track
  end

  ffi.copy(track.ysi, audio)
  for i = 0,track.count-1 do
    track.ys[i] = track.ysi[i]
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
    drawTracks(ig)
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

function drawTracks(ig)
  ig.Begin("Audio tracks")
  for tid, track in pairs(tracks) do
    ig.ImPlot_SetNextPlotLimits(0, track.count, -32768, 32767, 0)
    if ig.ImPlot_BeginPlot("Track #"..tostring(tid), "Time", "Value", ig.ImVec2(-1,200)) then
      ig.ImPlot_PlotLine("audio", track.xs, track.ys, track.count)
      ig.ImPlot_EndPlot()
    end
    ig.Separator();
  end
  ig.End()
end

return {
    draw = draw
}