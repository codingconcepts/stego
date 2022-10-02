require "./src/stego/canvas"
require "stumpy_png"

include StumpyPNG

scanvas = StumpyPNG.read("examples/input.png")
canvas = Stego::Canvas.new(scanvas)
canvas.conceal("The quick brown fox jumps over the lazy dog")
canvas.write("examples/output.png")

scanvas = StumpyPNG.read("examples/output.png")
canvas = Stego::Canvas.new(scanvas)
puts canvas.reveal()
