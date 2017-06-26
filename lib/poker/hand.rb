module Poker
  class Hand
    attr_reader :cards

    def initialize(cards)
      raise cards_error(cards) if cards.size != 5

      @cards = cards.collect do |card_sym|
        Card.new(card_sym)
      end
    end

    private

    def cards_error(cards_num)
      Poker::Errors::NumberOfCardsError.new(cards: cards)
    end
  end
end
