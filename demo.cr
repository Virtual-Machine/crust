require "./src/crust"

# This file shows a simplified use of crust's intended purpose
# This short script ensures the bin/ directory exists, cleans it out
# Release builds all .cr files in ./directory/ into ./bin
# Executes all built binaries in ./bin with given input, logging to log_file

ensure_bin_dir
clear_bin_dir
get_files "./directory/", ["cr"] do |demo_file|
  release_build demo_file, "bin/#{binary_name demo_file}"
end
get_files "./bin" do |bin_file|
  run_binary bin_file, "running:#{bin_file}", "log_file"
end
