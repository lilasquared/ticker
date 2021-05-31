# frozen_string_literal: true

require 'money'
require 'paint'

Money.locale_backend = :currency
Money.rounding_mode = BigDecimal::ROUND_HALF_UP

# a single position in a portfolio
class Position
  attr_reader :symbol, :shares, :cost_basis, :current_price

  def initialize(symbol:, shares:, cost_basis:, current_price:)
    @symbol = symbol
    @shares = shares
    @cost_basis = Money.from_amount(cost_basis, 'USD')
    @current_price = Money.from_amount(current_price, 'USD')
  end

  def original_value
    shares * cost_basis
  end

  def current_value
    shares * current_price
  end

  def change
    current_value - original_value
  end

  def change_percent
    change / original_value * 100
  end
end
