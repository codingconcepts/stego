require "./src/stego/canvas"
require "stumpy_png"

include StumpyPNG

puts "
 ████  █████ ██████  ████   ████  
▓        ▓   ▓      ▓    ▓ ▓    ▓ 
 ▒▒▒▒    ▒   ▒▒▒▒▒  ▒      ▒    ▒ 
     ▒   ▒   ▒      ▒  ▒▒▒ ▒    ▒ 
 ░░░░    ░   ░░░░░░  ░░░░   ░░░░ 

"

puts "Conceal or Reveal (c)/r"
mode = gets.not_nil!.chomp.downcase

case mode
when "", "c"
    conceal()
when "r"
    reveal()
end

def conceal()
    puts "Enter text to conceal:"
    text = STDIN.noecho &.gets.not_nil!.try &.chomp

    puts "Enter path to PNG carrier image input:"
    input_path = gets.not_nil!.chomp

    puts "Enter path to PNG carrier image ouput (or leave empty to overwrite input):"
    output_path = gets || input_path

    scanvas = StumpyPNG.read(input_path)
    canvas = Stego::Canvas.new(scanvas)
    canvas.conceal(text)
    canvas.write(output_path)
end

def reveal()
    puts "Enter path to PNG carrier image ouput:"
    output_path = gets.not_nil!.chomp

    scanvas = StumpyPNG.read(output_path)
    canvas = Stego::Canvas.new(scanvas)

    puts ""
    puts canvas.reveal()
end