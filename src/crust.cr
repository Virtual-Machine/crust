def recurse(mode : Symbol, dir : String, &block : String ->) : Nil
  Dir.glob(dir_to_glob :recurse, dir, nil) do |file|
    if ignore_item?(mode, file)
      # Ignore this item
    else
      block.call(file)
    end
  end
end

def recurse_files(dir : String, ext : Array(String), &block : String ->) : Nil
  Dir.glob(dir_to_glob :recurse, dir, ext) do |file|
    block.call(file)
  end
end

def get_files(dir : String, ext : Array(String), &block : String ->) : Nil
  Dir.glob(dir_to_glob :get, dir, ext) do |file|
    block.call(file)
  end
end

def get_files(dir : String, &block : String ->) : Nil
  Dir.glob(dir_to_glob :get, dir, nil) do |file|
    block.call(file)
  end
end

def release_build(src : String, bin : String) : Nil
  system "crystal build --release --no-debug -o #{bin} #{src}"
end

def run_binary(bin : String, input : String, log : String)
  system "./#{bin} #{input} >> #{log}"
end

def ensure_bin_dir : Nil
  system "mkdir -p bin"
end

def clear_bin_dir : Nil
  system "rm -f bin/*"
end

def binary_name(file : String) : String
  return File.basename file, ".cr"
end

private def strip_trailing_slash(dir : String) : String
  return dir[-1] == '/' ? dir[0...-1] : dir
end

private def extensions_to_glob_list(ext : Array(String) | Nil) : String
  if ext
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
