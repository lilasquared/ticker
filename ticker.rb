# frozen_string_literal: true

require_relative 'console_formatter'
require_relative 'portfolio'
require 'yaml'

config = YAML.safe_load(File.read('ticker.yml'))
portfolio = Portfolio.new(config)
formatter = ConsoleFormatter.new(portfolio)

exit_requested = !ARGV[0]&.match?(/loop/)
interval = ARGV[0]&.split('=')&.[](1)&.to_i || 5

Kernel.trap('INT') { exit_requested = true }

loop do
  system 'clear'

  formatter.print

  break if exit_requested

  sleep interval
end
