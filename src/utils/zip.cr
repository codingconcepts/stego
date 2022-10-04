require "compress/zip"

module Utils
  def create_in_memory_zip(input_files : Array(String))
    input = IO::Memory.new

    Compress::Zip::Writer.open(input) do |zip|
      input_files.each do |path|
        zip.add(Path[path].basename, File.open(path))
      end
    end

    input.to_slice
  end

  def list_files(io : IO)
    zip = Compress::Zip::Reader.new(io)
    zip.each_entry do |entry|
      puts "  - #{entry.filename}"
    end
  end
end
