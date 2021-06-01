# frozen_string_literal: true

require 'httparty'
require 'paint'
require 'ticker/position'

module Ticker
  # encapsulates a stock portfolio
  class Portfolio
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def positions
      @positions ||= data.map(&method(:position))
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

    def position(data)
      symbol = data['symbol']
      Position.new(
        symbol: symbol,
        units: config[symbol]['units'],
        cost_basis: config[symbol]['cost_basis'],
        data: data,
      )
    end

    def data
      @data ||= HTTParty.get(endpoint, options).parsed_response['quoteResponse']['result']
    end

    def fields
      %w[symbol marketState regularMarketPrice regularMarketChange regularMarketChangePercent
         preMarketPrice preMarketChange preMarketChangePercent postMarketPrice postMarketChange
         postMarketChangePercent].join(',')
    end

    def symbols
      config.keys.join(',')
    end

    def options
      {
        query: {
          fields: fields,
          symbols: symbols,
        },
        headers: {
          'user-agent': 'Mozilla/5.0',
        },
      }
    end

    def endpoint
      'https://query1.finance.yahoo.com/v7/finance/quote?lang=en-US&region=US'
    end
  end
end
