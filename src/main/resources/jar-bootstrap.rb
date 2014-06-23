# workaround to skip nokogiri jar checking
$LOAD_PATH << './appengine-rack'

# workaround for excon issue #257 (JRUBY-6970)
ENV['SSL_CERT_DIR'] = ENV['SSL_CERT_DIR'] || '/etc/ssl/certs'

require 'optparse'
require 'fucking_shell_scripts'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: fss [options] type"

  opts.on('--build', 'Only build the server' ) do |build|
    options[:build] = true
  end

  opts.on('--configure', 'Only configure the server' ) do |configure|
    options[:configure] = true
  end

  opts.on('--instance-id ID', 'An exiting AWS instance ID' ) do |id|
    options[:instance_id] = id
  end

  opts.on('-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end

  opts.on('-v', '--version', 'Show version' ) do
    puts FuckingShellScripts::VERSION
    exit
  end
end.parse!

options.merge!(type: ARGV.first)

abort("Specify the type of server to build/configure as the first argument (ie. fss app-server)") unless options[:type]

cli = FuckingShellScripts::CLI.new(options)

if options[:build]
  cli.build

elsif options[:configure]
  abort("Specify the server instance ID to configure using the --instance-id option") unless options[:instance_id]
  cli.configure

else
  cli.bootstrap
end

