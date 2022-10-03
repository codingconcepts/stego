require "./src/stego/canvas"
require "./src/utils/zip"
require "stumpy_png"

include StumpyPNG
include Utils

puts "
 ████  █████ ██████  ████   ████  
▓        ▓   ▓      ▓    ▓ ▓    ▓ 
 ▒▒▒▒    ▒   ▒▒▒▒▒  ▒      ▒    ▒ 
     ▒   ▒   ▒      ▒  ▒▒▒ ▒    ▒ 
 ░░░░    ░   ░░░░░░  ░░░░   ░░░░ 

"

case ARGV.size
when 0
    interactive_mode()
when 1
    output_png_path = ARGV[0]
    raise "Please provide a PNG file to reveal." if Path[output_png_path].extension != ".png"

    reveal_file(output_png_path)
else
    input_png_path = ARGV.select{|f| File.file?(f) && Path[f].extension == ".png"}
    raise "Please provide 1 PNG carrier image input." if input_png_path.size > 1

    input_files = ARGV.select{|f| File.file?(f) && Path[f].extension != ".png"}
    raise "Please provide at least 1 file to conceal." if input_files.size == 0

    conceal_file(input_png_path[0], input_files)
end

def interactive_mode()
    puts "Conceal or Reveal (c)/r"
    mode = gets.not_nil!.chomp.downcase

    case mode
    when "", "c"
        puts "Enter text to conceal:"
        text = STDIN.noecho &.gets.not_nil!.try &.chomp

        puts "Enter path to PNG carrier image input:"
        input_png_path = gets.not_nil!.chomp

        puts "Enter path to PNG carrier image ouput (or leave empty to overwrite input):"
        output_png_path = gets || input_png_path

        conceal_text(text, input_png_path, output_png_path)
    when "r"
        puts "Enter path to PNG carrier image ouput:"
        output_png_path = gets.not_nil!.chomp

        reveal_text(output_png_path)
    end
end

def conceal_text(text : String, input_png_path : String, output_png_path : String)
    scanvas = StumpyPNG.read(input_png_path)
    canvas = Stego::Canvas.new(scanvas)
    canvas.conceal(text.bytes)
    canvas.write(output_png_path)
end

def conceal_file(input_png_path : String, input_files : Array(String))
    puts "Concealing #{input_files} in #{input_png_path}"
    puts ""
    puts "Enter path to PNG carrier image ouput (or leave empty to overwrite input):"
    output_png_path = gets || input_png_path
    
    zip = create_in_memory_zip(input_files)
    scanvas = StumpyPNG.read(input_png_path)
    canvas = Stego::Canvas.new(scanvas)
    canvas.conceal(zip.to_a)
    canvas.write(output_png_path)
end

def reveal_text(output_png_path : String)
    scanvas = StumpyPNG.read(output_png_path)
    canvas = Stego::Canvas.new(scanvas)

    puts ""
    puts String.new(canvas.reveal())
end

def reveal_file(output_png_path : String)
    puts "Revealing #{output_png_path} into stego.zip"

    scanvas = StumpyPNG.read(output_png_path)
    canvas = Stego::Canvas.new(scanvas)

    zip = canvas.reveal()
    io = IO::Memory.new(zip)

    list_files(io)
    io.rewind

    # Create a zip file containing the concealed files.
    File.open("stego.zip", "w") do |file|
        IO.copy io, file
    end
end