function draw(ig)
    ig.Begin("Connect")
    if ig.Button("Hello") then
        print "Hello World!!"
    end
    ig.End()
end

return {
    draw = draw
}