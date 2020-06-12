package.path = package.path .. ';lib/luajit-glfw/?.lua;lib/luajit-imgui/lua/?.lua;lua/?.lua'

-- setup
local ffi = require "ffi"
local lj_glfw = require"glfw"
local gllib = require"gl"
gllib.set_loader(lj_glfw)
local gl, glc, glu, glext = gllib.libraries()
local ig = require"imgui.glfw"
lj_glfw.setErrorCallback(function(error,description)
    print("GLFW error:",error,ffi.string(description or ""));
end)
lj_glfw.init()
local window = lj_glfw.Window(1024, 768)
window:makeContextCurrent() 

local ig_impl = ig.Imgui_Impl_glfw_opengl3() --standard imgui opengl3 example
local igio = ig.GetIO()
igio.ConfigFlags = ig.lib.ImGuiConfigFlags_NavEnableKeyboard + igio.ConfigFlags
ig_impl:Init(window, true)


local app = require("app")

while not window:shouldClose() do
    lj_glfw.pollEvents()
    gl.glClearColor(0.45, 0.55, 0.60, 1.0)
    gl.glClear(glc.GL_COLOR_BUFFER_BIT)
    ig_impl:NewFrame()
    app.draw(ig)
    
    ig_impl:Render()
    window:swapBuffers()
end

ig_impl:destroy()
window:destroy()
lj_glfw.terminate()