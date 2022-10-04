require "../utils/bits"
require "bit_array"
require "stumpy_png"

include StumpyPNG
include Utils

module Stego
  class Canvas
    def initialize(@canvas : StumpyPNG::Canvas)
    end

    def conceal(message : Array(UInt8))
      bits = bytes_to_bits(message)
      size_bits = bitarray_to_bits(num_bits(bits.size))
      size_bits = size_bits + bits

      max_message_size = @canvas.width * @canvas.height * 3
      raise "Message is too big for image" if size_bits.size > max_message_size

      size_bits.each_with_index do |b, i|
        set_rgb(i, b)
      end
    end

    def stats
      puts ""
      puts "Dimensions  = #{@canvas.width}x#{@canvas.height}"
      puts "Can conceal = #{((@canvas.width * @canvas.height * 3) // 8).humanize_bytes}"
    end

    def reveal : Bytes
      # Fetch the number of message bits from the first 32 canvas bits.
      msg_size = get_num_bits()

      # Read the messages into a bit array.
      msg_bits = BitArray.new(msg_size)
      x = 0

      32.upto(32 + msg_size - 1) do |i|
        msg_bits[x] = get_lsb(get_rgb_part(i)) == 1
        x += 1
      end

      msg_bits.reverse!

      msg_bytes = msg_bits.to_slice.reverse!
      msg_bytes
    end

    def get_num_bits : Int
      bits = BitArray.new(32)
      0.upto(31) do |i|
        bits[i] = get_lsb(get_rgb_part(i)) == 1
      end

      bits.map { |b| b ? 1 : 0 }.join("").to_i(2)
    end

    def write(path : String)
      StumpyPNG.write(@canvas, path)
    end

    def get_rgb_part(i : Int) : UInt8
      r, g, b = get_rgb(i)

      case i % 3
      when 0
        r
      when 1
        g
      else
        b
      end
    end

    def get_rgb(i : Int) : Tuple(UInt8, UInt8, UInt8)
      pixel = @canvas[i // (@canvas.width * 3), (i // 3) % @canvas.width]
      pixel.to_rgb8
    end

    def set_rgb(i : Int, value : UInt8)
      r, g, b = get_rgb(i)

      case i % 3
      when 0
        r = set_lsb(r, value)
      when 1
        g = set_lsb(g, value)
      else
        b = set_lsb(b, value)
      end

      color = RGBA.from_rgb(r, g, b)
      @canvas[i // (@canvas.width * 3), (i // 3) % @canvas.width] = color
    end
  end
end
