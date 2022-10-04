require "stumpy_png"
require "commander"
require "./src/stego/canvas"
require "./src/utils/os"
require "./src/utils/zip"

include StumpyPNG
include Utils

banner = "
████  █████ ██████  ████   ████
▓       ▓   ▓      ▓    ▓ ▓    ▓
▒▒▒▒    ▒   ▒▒▒▒▒  ▒      ▒    ▒
    ▒   ▒   ▒      ▒  ▒▒▒ ▒    ▒
░░░░    ░   ░░░░░░  ░░░░   ░░░░
"

input_flag = Commander::Flag.new do |flag|
  flag.name = "input_flag"
  flag.short = "-i"
  flag.long = "--input"
  flag.default = ""
  flag.description = "Absolute or relative path to the input image."
end

output_flag = Commander::Flag.new do |flag|
  flag.name = "output_flag"
  flag.short = "-o"
  flag.long = "--output"
  flag.default = ""
  flag.description = "Absolute or relative path to the output image."
end

glob_flag = Commander::Flag.new do |flag|
  flag.name = "glob_flag"
  flag.short = "-g"
  flag.long = "--glob"
  flag.default = "**/*"
  flag.description = "Glob pattern to use when concealing a directory."
end

cli = Commander::Command.new do |cmd|
  cmd.use = "stego"
  cmd.long = banner

  cmd.commands.add do |cmd|
    cmd.use = "conceal -i inconspicuous.png [files]"
    cmd.short = "Conceal files or a directory in an image, or leave blank to conceal text."
    cmd.long = cmd.short

    cmd.commands.add do |cmd|
      cmd.use = "text"
      cmd.short = "Conceal text in a PNG."
      cmd.long = cmd.short
      cmd.flags.add input_flag, output_flag
      cmd.run do |options, arguments|
        conceal_text(cmd, options, arguments)
      end
    end

    cmd.commands.add do |cmd|
      cmd.use = "file"
      cmd.short = "Conceal files or a directory in a PNG."
      cmd.long = cmd.short
      cmd.flags.add input_flag, output_flag, glob_flag
      cmd.run do |options, arguments|
        conceal_file(cmd, options, arguments)
      end
    end
  end

  cmd.commands.add do |cmd|
    cmd.use = "reveal -i inconspicuous.png"
    cmd.short = "Reveal files or a message."
    cmd.long = cmd.short

    cmd.commands.add do |cmd|
      cmd.use = "text"
      cmd.short = "Reveal text from a PNG."
      cmd.long = cmd.short
      cmd.flags.add input_flag
      cmd.run do |options, arguments|
        reveal_text(cmd, options, arguments)
      end
    end

    cmd.commands.add do |cmd|
      cmd.use = "file"
      cmd.short = "Reveal files or a directory from a PNG."
      cmd.long = cmd.short
      cmd.flags.add input_flag
      cmd.run do |options, arguments|
        reveal_file(cmd, options, arguments)
      end
    end
  end

  cmd.commands.add do |cmd|
    cmd.use = "stat"
    cmd.short = "Get stats for a PNG."
    cmd.long = cmd.short
    cmd.flags.add input_flag
    cmd.run do |options, arguments|
      stat(options, arguments)
    end
  end
end

def conceal_text(cmd, options, arguments)
  input_path = options.string["input_flag"]
  put_exit cmd.help if input_path == ""

  output_path = options.string["output_flag"]
  put_exit cmd.help if output_path == ""

  puts ""
  puts "Enter text to conceal:"
  text = gets.not_nil!

  scanvas = StumpyPNG.read(input_path)
  canvas = Stego::Canvas.new(scanvas)
  canvas.conceal(text.bytes)
  canvas.write(output_path)
end

def conceal_file(cmd, options, arguments)
  input_path = options.string["input_flag"]
  put_exit cmd.help if input_path == ""

  output_path = options.string["output_flag"]
  put_exit cmd.help if output_path == ""

  glob = options.string["glob_flag"]

  dirs = arguments.select { |a| File.directory? a }
    .map { |a| Path[a] / "**/*" }
    .map { |a| Dir.glob(a) }
    .flatten
    .select { |a| File.file? a }
    .select { |a| Path[a].extension != ".png" }

  files = arguments.select { |a| File.file? a }
    .flatten
    .select { |a| Path[a].extension != ".png" }

  files = (files + dirs).uniq

  put_exit "Please provide at least 1 file to conceal." if files.size == 0

  puts ""
  puts "Concealing file:"
  files.each { |f| puts "  - #{f}" }

  zip = create_in_memory_zip(files)
  scanvas = StumpyPNG.read(input_path)
  canvas = Stego::Canvas.new(scanvas)
  canvas.conceal(zip.to_a)
  canvas.write(output_path)
end

def reveal_text(cmd, options, arguments)
  input_path = options.string["input_flag"]
  put_exit cmd.help if input_path == ""

  scanvas = StumpyPNG.read(input_path)
  canvas = Stego::Canvas.new(scanvas)

  puts ""
  puts String.new(canvas.reveal)
end

def reveal_file(cmd, options, arguments)
  input_path = options.string["input_flag"]
  put_exit cmd.help if input_path == ""

  scanvas = StumpyPNG.read(input_path)
  canvas = Stego::Canvas.new(scanvas)

  zip = canvas.reveal
  io = IO::Memory.new(zip)

  puts ""
  list_files(io)
  io.rewind

  # Create a zip file containing the concealed files.
  File.open("stego.zip", "w") do |file|
    IO.copy io, file
  end
end

def stat(options, arguments)
  image_path = options.string["input_flag"]
  put_exit "Please provide at least 1 file to conceal." if Path[image_path].extension != ".png"

  scanvas = StumpyPNG.read(image_path)
  canvas = Stego::Canvas.new(scanvas)

  canvas.stats
end

Commander.run(cli, ARGV)
