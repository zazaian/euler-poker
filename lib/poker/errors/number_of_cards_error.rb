module Poker
  module Errors
    class NumberOfCardsError < StandardError
      attr_reader :cards

      def initialize(cards:, message: nil)
        @cards = cards
        @message = message
      end

      def to_s
        @message || default_message
      end

      def default_message
        "This hand has #{cards.size} cards, but should have exactly 5."
      end
    end
  end
end

