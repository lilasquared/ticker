# frozen_string_literal: true

require 'yaml'
require 'ticker/portfolio'

module Ticker
  # formats a portfolio for output
  class ConsoleFormatter
    def initialize(portfolio, options = {})
      @portfolio = portfolio
      @options = options
    end

    def print
      print_header
      @portfolio.positions.each(&method(:print_position))
      print_footer
    end

    private

    def print_header
      puts 'SYMBOL'.ljust(10) +
           'PRICE'.rjust(10) +
           'UNITS'.rjust(15) +
           'VALUE'.rjust(15) +
           '$ CHANGE'.rjust(15) +
           '% CHANGE'.rjust(10) +
           'DAY CHANGE'.rjust(15)
      puts '-' * 90
    end

    def print_position(position)
      puts format_value(position.symbol, 10, method: :ljust) +
           format_value(position.current_price, 10) +
           format_value(position.units, 15) +
           format_value(position.current_value, 15, effect: :bold) +
           format_change(position.change, 15) +
           format_change(position.change_percent.round(2), 10) +
           format_change(position.day_change, 15)
      sleep 0.1
    end

    def print_footer
      puts '-' * 90
      puts format_value('TOTAL', 10, method: :ljust) +
           format_value('-', 10) +
           format_value('-', 15) +
           format_value(@portfolio.total, 15, effect: :bold) +
           format_change(@portfolio.change, 15) +
           format_change(@portfolio.percent.round(2), 10) +
           format_change(@portfolio.day_change, 15)
    end

    def format_change(value, width)
      Paint[stringify(value).rjust(width), color(value)]
    end

    def format_value(value, width, options = {})
      Paint[stringify(value).send(options[:method] || :rjust, width),
            options[:color] || :white,
            options[:effect] || :nothing]
    end

    def color(value)
      value.positive? ? :green : :red
    end

    def stringify(value)
      return value.format(symbol: '') if value.is_a?(Money)

      value.to_s
    end
  end
end
