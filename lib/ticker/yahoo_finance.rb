# frozen_string_literal: true

require 'httparty'

module Ticker
  # a single position in a portfolio
  class YahooFinance
    ENDPOINT = 'https://query1.finance.yahoo.com/v7/finance/quote?lang=en-US&region=US'

    def self.get_quote(symbols)
      HTTParty.get(ENDPOINT, options(symbols)).parsed_response['quoteResponse']['result']
    end

    def self.fields
      %w[symbol marketState regularMarketPrice regularMarketChange regularMarketChangePercent
         preMarketPrice preMarketChange preMarketChangePercent postMarketPrice postMarketChange
         postMarketChangePercent]
    end

    def self.options(symbols)
      {
        query: {
          fields: fields.join(','),
          symbols: symbols.join(','),
        },
        headers: {
          'user-agent': 'Mozilla/5.0',
        },
      }
    end
  end
end
