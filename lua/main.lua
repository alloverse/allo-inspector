-- setup alloverse
local srcDir = "lua"
local libDir = "lib"
package.cpath = string.format("%s;%s/?.so;%s/?.dylib;%s/?.dll", package.cpath, srcDir, srcDir, srcDir)
package.path = string.format(
    "%s;%s/?.lua;%s/alloui/lua/?.lua;%s/alloui/lib/cpml/?.lua;%s/alloui/lib/pl/lua/?.lua",
    package.path,
    srcDir,
    libDir,
    libDir,
    libDir
)

local status = pcall(require, "liballonet")
if status == false then
    require("allonet")
end
ui = require("alloui.ui")

-- setup Dear IMGUI
package.path = package.path .. ';lib/luajit-glfw/?.lua;lib/luajit-imgui/lua/?.lua;lua/?.lua'
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

local showdemo = ffi.new("bool[1]",false)
while not window:shouldClose() do
    lj_glfw.pollEvents()
    gl.glClearColor(0.45, 0.55, 0.60, 1.0)
    gl.glClear(glc.GL_COLOR_BUFFER_BIT)
    ig_impl:NewFrame()
    app.draw(ig)
    
    --ig.ShowDemoWindow(showdemo)

    ig_impl:Render()
    window:swapBuffers()
end

ig_impl:destroy()
window:destroy()
lj_glfw.terminate()
