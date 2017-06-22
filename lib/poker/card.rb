module Poker
  class Card
    SUITS = %w[H D C S]
    RANKS = %w[A 2 3 4 5 6 7 8 9 T J Q K A]

    attr_reader :rank, :suit

    def initialize(card_symbol)
      @rank = card_symbol[0]
      @suit = card_symbol[1]
    end

  end
end
