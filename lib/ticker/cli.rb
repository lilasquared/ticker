# frozen_string_literal: true

require 'thor'
require 'yaml'
require 'ticker/console_formatter'
require 'ticker/portfolio'
require 'ticker/root_path'
require 'ticker/yahoo_finance'

module Ticker
  # ticker app
  class CLI < Thor
    desc 'add SYMBOL -u 100 -c 100', 'Add a position to your portfolio'
    method_option :units, aliases: '-u', desc: 'Specify a quantity of units'
    method_option :cost_basis, aliases: '-c', desc: 'Specify a cost bais (in dollars)'
    def add(symbol)
      portfolio_config[symbol] = {
        'units' => options[:units].to_f,
        'cost_basis' => options[:cost_basis].to_f,
      }
      save
    end

    desc 'remove SYMBOL', 'Remove a position from your portfolio'
    def remove(symbol)
      portfolio_config.tap { |c| c.delete(symbol) }
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

    desc 'install', 'Install ticker'
    def install
      bin_dir = '/usr/local/bin'
      ticker_path = File.join(bin_dir, 'ticker')
      if File.exist?(ticker_path)
        puts "Symlink to #{ticker_path} already exists, skipping."
      else
        exe_path = Ticker.root_path('exe', 'ticker')
        puts "Creating symlink to #{ticker_path}..."
        File.symlink(exe_path, ticker_path)
      end
    end

    private

    def config
      @config ||= File.exist?('ticker.yml') ? YAML.safe_load(File.read('ticker.yml')) : {}
    end

    def portfolio_config
      config['portfolio']
    end

    def output_config
      config['output']
    end

    def symbols
      portfolio_config.keys
    end

    def data
      YahooFinance.get_quote(symbols)
    end

    def portfolio
      Portfolio.new(portfolio_config, data)
    end

    def formatter
      ConsoleFormatter.new(portfolio, output_config)
    end

    def save
      File.write('ticker.yml', YAML.dump(config))
    end
  end
end
