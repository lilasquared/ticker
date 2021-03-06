# frozen_string_literal: true

require 'httparty'
require_relative 'response'

module Ticker
  module YahooFinance
    class API
      ENDPOINT = 'https://query1.finance.yahoo.com/v7/finance/quote?lang=en-US&region=US'

      def self.get_quotes(symbols)
        Response.new(HTTParty.get(ENDPOINT, options(symbols)).parsed_response).quotes
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
end
