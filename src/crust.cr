# Recurses a directory and calls the block on each item depending on mode
# mode can be :all, :dir, or :file
# :dir ignores files, :file ignores directories
def recurse(mode : Symbol, dir : String, &block : String ->) : Nil
  Dir.glob(dir_to_glob :recurse, dir, nil) do |file|
    if ignore_item?(mode, file)
      # Ignore this item
    else
      block.call(file)
    end
  end
end

# Recurses a directory and calls the block on each file if it matches an extension in provided array
def recurse_files(dir : String, ext : Array(String), &block : String ->) : Nil
  Dir.glob(dir_to_glob :recurse, dir, ext) do |file|
    block.call(file)
  end
end

# Calls block on each file in directory that matches an extension in provided list
def get_files(dir : String, ext : Array(String), &block : String ->) : Nil
  Dir.glob(dir_to_glob :get, dir, ext) do |file|
    block.call(file)
  end
end

# Calls block on each file in directory
def get_files(dir : String, &block : String ->) : Nil
  Dir.glob(dir_to_glob :get, dir, nil) do |file|
    block.call(file)
  end
end

# Build binary with name bin using src
def release_build(src : String, bin : String) : Nil
  system "crystal build --release --no-debug -o #{bin} #{src}"
end

# Run binary with input string and output to log file
def run_binary(bin : String, input : String, log : String) : Nil
  output = IO::Memory.new
  Process.run(bin, args: {"postgres://localhost:5432/test?prepared_statements=false&initial_pool_size=1&max_pool_size=1&max_idle_pool_size=1"}, output: output)
  output.close
  File.open(log, "a") do |f|
    f << bin
    f << '\n'
    f << output
    f << '\n'
  end
end

# Ensure bin directory exists in current directory.
# If bin already exists, no error is raised.
def ensure_bin_dir : Nil
  system "mkdir -p bin"
end

# Delete all items from bin/ USE WITH CAUTION
def clear_bin_dir : Nil
  system "rm -f bin/*"
end

# Get the base name of a crystal file for use as binary name
# Ex. /path/to/file.cr => file
def binary_name(file : String) : String
  return File.basename file, ".cr"
end

private def strip_trailing_slash(dir : String) : String
  return dir[-1] == '/' ? dir[0...-1] : dir
end

private def extensions_to_glob_list(ext : Array(String) | Nil) : String
  if ext
    ext.each_with_index do |e, i|
      ext[i] = e[0] == '.' ? e[1..-1] : e
    end
    return ".{#{ext.join(',')}}"
  else
    return ""
  end
end

private def dir_to_glob(mode : Symbol, dir : String, ext : Array(String) | Nil) : String
  search = mode == :recurse ? "/**/*" : "/*"
  return strip_trailing_slash(dir) + search + extensions_to_glob_list(ext)
end

private def ignore_item?(mode : Symbol, file : String) : Bool
  return mode == :dir && File.file?(file) || mode == :file && !File.file?(file)
end
