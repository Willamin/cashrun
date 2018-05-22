require "./cashrun/*"

module Cashrun
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}
end

config, script_name, remaining_args = Cashrun::CLI.parse
config.parse_file!
STDERR.puts "Config: #{config}" if config.verbose
STDERR.puts "Running #{script_name}" if config.verbose

unless File.exists?(script_name)
  STDERR.puts "Origin script does not exist."
  exit 1
end

hexdigest = config.digest.class.hexdigest(File.read(script_name))
STDERR.puts "Hex Digest: #{hexdigest}" if config.verbose

cached_name = File.expand_path(File.join(config.cache_directory, hexdigest))
STDERR.puts "Cached Name: #{cached_name}" if config.verbose

unless Dir.exists?(File.expand_path(config.cache_directory))
  STDERR.puts "Cache Directory does not exist." if config.verbose
  Dir.mkdir_p(File.expand_path(config.cache_directory))
end

unless File.exists?(cached_name)
  STDERR.puts "Cached executable does not exist." if config.verbose
  Process.run(command: "crystal", args: [script_name, "-o", cached_name])
end

Process.exec(command: cached_name, args: remaining_args)
