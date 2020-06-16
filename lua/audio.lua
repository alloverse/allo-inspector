
local buffered_sample_count = 48000
local bufferskip = 4 -- 48000 points is 4 times too many to render
local actual_sample_count = buffered_sample_count / bufferskip
local tracks = {}
function onAudio(trackId, audio)
  local track = tracks[trackId]
  local sampleCount = #audio / 2
  if track == nil then
    track = {
      xs = ffi.new("float[?]", actual_sample_count),
      ysi = ffi.new("short[?]", 960),
      ys = ffi.new("float[?]", actual_sample_count),
      count = actual_sample_count,
      offset = 0
    }
    for i = 0,track.count-1 do
      track.xs[i] = i * bufferskip
    end
    tracks[trackId] = track
  end

  ffi.copy(track.ysi, audio)
  if track.offset + sampleCount/bufferskip >= actual_sample_count then
    track.offset = 0
  end
  for i = 0,sampleCount-1, bufferskip do
    track.ys[track.offset + i/bufferskip] = track.ysi[i]
  end
  track.offset = track.offset + sampleCount/bufferskip
end


function drawTracks(w, ig)
  ig.Begin("Audio tracks in"..w.client.placename)
  for tid, track in pairs(tracks) do
    ig.ImPlot_SetNextPlotLimits(0, track.count * bufferskip, -32768, 32767, 0)
    if ig.ImPlot_BeginPlot("Track #"..tostring(tid), "Time", "Value", ig.ImVec2(-1,200)) then
      ig.ImPlot_PlotLine("audio", track.xs, track.ys, track.count)
      ig.ImPlot_EndPlot()
    end
    ig.Separator();
  end
  ig.End()
end

return function(client)
    client.client:set_audio_callback(onAudio)
    return {
        client = client,
        draw = drawTracks
    }
end
