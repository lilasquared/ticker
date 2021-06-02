# frozen_string_literal: true

require 'money'

Money.locale_backend = :currency
Money.rounding_mode = BigDecimal::ROUND_HALF_UP

module Ticker
  # a single position in a portfolio
  class Position
    attr_reader :symbol, :units, :cost_basis

    def initialize(symbol:, units:, cost_basis:, data:)
      @symbol = symbol
      @units = units
      @cost_basis = money(cost_basis)
      @data = data
    end

    def regular_market_price
      @regular_market_price ||= @data['regularMarketPrice']
    end

    def current_price
      @current_price ||= money(@data["#{state}MarketPrice"] || regular_market_price)
    end

    def original_value
      units * cost_basis
    end

    def current_value
      units * current_price
    end

    def change
      current_value - original_value
    end

    def change_percent
      change / original_value * 100
    end

    def _day_change
      money(@data['regularMarketChange'])
    end

    def day_change
      units * _day_change
    end

    private

    def state
      @data['marketState'].downcase
    end

    def money(amount)
      Money.from_amount(amount, 'USD')
    end
  end
end
