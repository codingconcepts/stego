module Utils
  def string_to_bits(input : String) : Array(UInt8)
    bytes_to_bits(input.bytes)
  end

  def bytes_to_bits(input : Array(UInt8)) : Array(UInt8)
    output = Array(UInt8).new
    input.each do |byte|
      7.downto(0) do |bit|
        output << byte.bit(bit)
      end
    end

    output
  end

  def bitarray_to_bits(input : BitArray) : Array(UInt8)
    output = Array(UInt8).new
    input.each do |b|
      if b
        output << 1
      else
        output << 0
      end
    end

    output.reverse
  end

  def num_bits(n : Int) : BitArray
    bits = BitArray.new(32)

    0.upto(n.bit_length) do |i|
      bits[i] = n.bit(i) == 1
    end

    bits
  end

  def set_lsb(n : UInt8, new : UInt8)
    new_bit = new & (1 << 0)

    if new_bit > 0
      n |= 2 ** 0
    else
      n & ~(1 << 0)
    end
  end

  def get_lsb(n : UInt8)
    n.bit(0)
  end
end
