# frozen_string_literal: true

require 'httparty'
require 'ticker/underscore'

module Ticker
  module YahooFinance
    class Quote
      def initialize(data)
        @data = data
        define_methods
      end

      def [](key)
        @data[key]
      end

      private

      def define_methods
        @data.each_key do |key|
          self.class.send(:define_method, key.underscore) do
            @data[key]
          end
        end
      end
    end
  end
end
