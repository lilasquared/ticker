# frozen_string_literal: true

require_relative 'console_formatter'
require_relative 'portfolio'
require 'thor'
require 'yaml'

# ticker app
class Ticker < Thor
  desc 'add SYMBOL -u 100 -c 100', 'Add a position to your portfolio'
  method_option :units, aliases: '-u', desc: 'Specify a quantity of units'
  method_option :cost_basis, aliases: '-c', desc: 'Specify a cost bais (in dollars)'
  def add(symbol)
    config[symbol] = {
      'units' => options[:units].to_f,
      'cost_basis' => options[:cost_basis].to_f
    }
    save
  end

  desc 'remove SYMBOL', 'Remove a position from your portfolio'
  def remove(symbol)
    config.tap { |c| c.delete(symbol) }
    save
  end

  desc 'monitor -i 10', 'Monitor your portfolio with specified interval'
  method_option :interval, aliases: '-i', desc: 'Specify a loop interval in seconds (default 5)'
  def monitor
    interval = options[:interval]&.to_i || 5
    exit_requested = false

    Kernel.trap('INT') { exit_requested = true }

    until exit_requested
      print
      sleep interval
    end
  end

  desc 'print', 'Print out your portfolio just once'
  def print
    system 'clear'
    formatter.print
  end

  private

  def config
    @config ||= YAML.safe_load(File.read('ticker.yml'))
  end

  def portfolio
    @portfolio ||= Portfolio.new(config)
  end

  def formatter
    @formatter ||= ConsoleFormatter.new(portfolio)
  end

  def save
    File.write('ticker.yml', YAML.dump(config))
  end
end

Ticker.start
