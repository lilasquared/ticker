# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'ticker'

def boot_ticker
  $0 = 'ticker'

  begin
    Ticker::CLI.start
  rescue StandardError => e
    puts "ERROR: #{e.message}"
    puts e.backtrace
    exit 1
  end
end
