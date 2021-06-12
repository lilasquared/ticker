# frozen_string_literal: true

require 'httparty'
require_relative 'quote'

module Ticker
  module YahooFinance
    class Response
      def initialize(response_hash)
        @response_hash = response_hash
      end

      def quotes
        @response_hash.dig('quoteResponse', 'result').map(&method(:quote))
      end

      private

      def quote(data)
        Quote.new(data)
      end
    end
  end
end
