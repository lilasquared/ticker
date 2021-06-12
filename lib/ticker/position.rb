# frozen_string_literal: true

require 'money'

Money.locale_backend = :currency
Money.rounding_mode = BigDecimal::ROUND_HALF_UP

module Ticker
  # a single position in a portfolio
  class Position
    def initialize(quote:, config:)
      @quote = quote
      @config = config
    end

    def symbol
      @quote.symbol
    end

    def units
      if @config.is_a?(Hash)
        @config['units']
      else
        @config.sum { |h| h['units'] }
      end
    end

    def cost_basis
      if @config.is_a?(Hash)
        money(@config['cost_basis'])
      else
        money(@config.reduce(0) { |cost, hash| cost + hash['cost_basis'] * hash['units'] } / units)
      end
    end

    def unit_price
      @unit_price ||= money(@quote["#{market_state}MarketPrice"] ||
        @quote.post_market_price ||
        @quote.regular_market_price)
    end

    def original_value
      units * cost_basis
    end

    def current_value
      units * unit_price
    end

    def total_change
      current_value - original_value
    end

    def total_change_percent
      total_change / original_value * 100
    end

    def day_change
      units * money(@quote["#{market_state}MarketChange"] ||
        @quote.post_market_change ||
        @quote.regular_market_change)
    end

    def day_change_percent
      @quote["#{market_state}MarketChangePercent"] ||
        @quote.post_market_change_percent ||
        @quote.regular_market_change_percent
    end

    private

    def market_state
      @quote.market_state.downcase
    end

    def money(amount)
      Money.from_amount(amount, 'USD')
    end
  end
end
