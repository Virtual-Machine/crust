# crust

Helper functions to write build/shell scripts with Crystal


## Examples

```crystal
require "crust"


###
# Exposed Helpers Examples
###

# Print all files or directories recursively in /directory/
recurse :all, "./directory/" do |item|
  puts item
end

# Print all directories recursively in /directory/
recurse :dir, "./directory/" do |item|
  puts item
end

# Print all files recursively in /directory/
recurse :file, "./directory/" do |item|
  puts item
end

# Print all files recursively in /directory/ with either .cr, .rb or .yml extension
recurse_files "./directory/", ["cr", "rb", "yml"] do |item|
  puts item
end

# Execute all files in /directory/ with .rb extension
get_files "./directory/", ["rb"] do |item|
  system "ruby #{item}"
end

# Read all files in /directory/ with .yml extension
get_files "./directory/", ["yml"] do |item|
  system "cat #{item}"
end

# Ensure bin directory exists
ensure_bin_dir

# Ensure bin directory is empty
clean_bin_dir

# Build release binary as bin/specimen using src/specimen.cr
release_build("src/specimen.cr", "bin/specimen")

# Run binary with given input to file
run_binary("bin/demo", "input_to_file", "log_file")

```

Also see demo.cr