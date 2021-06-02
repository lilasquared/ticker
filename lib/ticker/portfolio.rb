# frozen_string_literal: true

require 'httparty'
require 'paint'
require 'ticker/position'

module Ticker
  # encapsulates a stock portfolio
  class Portfolio
    def initialize(config, data)
      @config = config
      @data = data
    end

    def positions
      @data.map(&method(:position))
        .sort_by(&:change)
        .reverse
    end

    def total
      @total ||= positions.reduce(0) { |sum, position| sum + position.current_value }
    end

    def change
      @change ||= positions.reduce(0) { |sum, position| sum + position.change }
    end

    def percent
      change / (total - change) * 100
    end

    def day_change
      @day_change ||= positions.reduce(0) { |sum, position| sum + position.day_change }
    end

    private

    def position(quote)
      symbol = quote['symbol']
      Position.new(
        symbol: symbol,
        units: @config[symbol]['units'],
        cost_basis: @config[symbol]['cost_basis'],
        data: quote,
      )
    end
  end
end
