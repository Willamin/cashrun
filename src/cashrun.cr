require "./cashrun/*"

module Cashrun
  VERSION         = {{ `shards version #{__DIR__}`.chomp.stringify }}
  CRYSTAL_VERSION = {{ `crystal --version`.chomp.stringify }}
end

macro vputs(string)
  if config.verbose
    STDERR.puts {{string}}
  end
end

config, script_name, remaining_args = Cashrun::CLI.parse
config.parse_file!
vputs "Config: #{config}"
vputs "Running #{script_name}"

unless File.exists?(script_name)
  STDERR.puts "Origin script does not exist."
  exit 1
end

hexdigest = config.digest.class.hexdigest(File.read(script_name))
vputs "Hex Digest: #{hexdigest}"

cached_name = File.expand_path(File.join(config.cache_directory, hexdigest))
vputs "Cached Name: #{cached_name}"

unless Dir.exists?(File.expand_path(config.cache_directory))
  vputs "Cache Directory does not exist."
  Dir.mkdir_p(File.expand_path(config.cache_directory))
end

if config.uncache
  if File.exists?(cached_name)
    vputs "Uncaching file."
    File.delete(cached_name)
    exit 0
  end
end

unless File.exists?(cached_name)
  vputs "Cached executable does not exist."

  real_script_location = File.dirname(File.real_path(File.expand_path(script_name)))

  args = [
    "build",
    File.basename(script_name),
    "-o", cached_name,
    "--no-debug",
  ]

  if config.release
    args << "--release"
  end

  vputs "running `crystal #{args.join(" ")}` after chdir: `#{real_script_location}`"
  status = Process.run(command: "crystal", args: args, chdir: real_script_location, error: STDERR)
  unless status.success?
    exit 1
  end
end

vputs "running `#{cached_name} #{remaining_args.join(" ")}`"
Process.exec(command: cached_name, args: remaining_args)
