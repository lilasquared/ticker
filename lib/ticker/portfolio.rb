# frozen_string_literal: true

require 'httparty'
require 'paint'
require 'ticker/position'

module Ticker
  # encapsulates a stock portfolio
  class Portfolio
    def initialize(config, quotes)
      @config = config
      @quotes = quotes
    end

    def positions
      @quotes.map(&method(:position))
        .sort_by(&:current_value)
        .reverse
    end

    def original_value
      @original_value ||= positions.sum(&:original_value)
    end

    def current_value
      @current_value ||= positions.sum(&:current_value)
    end

    def total_change
      @total_change ||= positions.sum(&:total_change)
    end

    def total_change_percent
      total_change / original_value * 100
    end

    def day_change
      @day_change ||= positions.sum(&:day_change)
    end

    private

    def position(quote)
      Position.new(
        quote: quote,
        config: @config[quote.symbol],
      )
    end
  end
end
