require "option_parser"
require "digest"
require "./configuration"

class Cashrun::CLI
  def self.parse
    config = Cashrun::Configuration.default.to_partial
    script : String = ""

    OptionParser.new do |parser|
      parser.banner = "Usage: #{PROGRAM_NAME} [arguments] SCRIPT_FILE"
      parser.on("--config=CONFIG_FILE", "Specifies the configuration file to use") { |f| config.config_file = f }
      parser.on("--cache=CACHE_DIR", "Specifies the directory to use for storing cached binaries") { |d| config.cache_directory = d }
      parser.on("--hash=HASH", "Specifies the hash to use for the cache") { |h| config.digest = Cashrun::Configuration.decide_hash(h) || show_usage(parser) }
      parser.on("-h", "--help", "Show this help") { show_usage(parser) }
      parser.on("--verbose", "Be more verbose") { config.verbose = true }
      parser.unknown_args { |args| show_usage(parser) if args.size != 1; script = args[0] }

      parser.parse!
    end

    {config.unpartial, script}
  end

  def self.show_usage(parser)
    puts parser
    puts
    exit 1
  end
end
