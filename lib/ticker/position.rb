# frozen_string_literal: true

require 'money'

Money.locale_backend = :currency
Money.rounding_mode = BigDecimal::ROUND_HALF_UP

module Ticker
  # a single position in a portfolio
  class Position
    attr_reader :symbol, :units, :cost_basis, :current_price

    def initialize(symbol:, units:, cost_basis:, current_price:)
      @symbol = symbol
      @units = units
      @cost_basis = Money.from_amount(cost_basis, 'USD')
      @current_price = Money.from_amount(current_price, 'USD')
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
  end
end