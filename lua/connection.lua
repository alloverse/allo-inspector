local audio = require "audio"
local entities = require "entities"
local Client = require("alloui.client")

function connect(w, to)
  w.client = Client(to, "inspector")
  if w.client:connect({dummy={dummy=0}}) == true then
    w.app = App(w.client)
    w.client.client:set_audio_callback(onAudio)
  else
    w.client = nil
    w.error = "Failed to connect."
  end
end

function drawConn(w, ig)
    ig.Begin(w.client and w.client.placename or w.url)

    if w.error then
        ig.Text(error)
    else
        ig.Text("Connected.")
    end

    if ig.Button("Inspect entities") then
        w.openWindow(entities(w.client))
    end
    if ig.Button("Inspect audio") then
        w.openWindow(audio(w.client))
    end
    ig.End()
    w.client.client:poll()
end

return function(url)
    local w = {
        url = url,
        draw = drawConn
    }
    connect(w, url)
    return w
end
